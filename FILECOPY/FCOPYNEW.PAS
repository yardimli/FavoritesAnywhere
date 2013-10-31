unit fcopynew;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FileCtrl;

const
   BlockSize = $4000;

type

  // notify the copy progress in percentage
  TCopyProgressEvent = procedure(Sender: TObject;read, written : word) of object;
  // ask for overriding
  TOnOverriding = procedure(Sender : TObject;var CanOverride : boolean) of object;
  // notify an error
  TOnError = procedure(Sender : TObject;ErrorMsg : string) of object;

    pBuf = ^tBuf;
  TBuf = array[1..BlockSize] of char;

  TFileCopyNew = class(TComponent)
  private
    { Private declarations }
    FSourceFile         : string;
    FTargetFile         : string;
    FIncludeSubFolders  : boolean;
    FBuf                : pBuf;
    FMemo               : TMemo;
    FShowProgressOnMemo : boolean;
    // Events
    FOnCopyProgress     : TCopyProgressEvent;
    FOnOverriding       : TOnOverriding;
    FOnError            : TOnError;
    function  GetIncludeSubFolders : boolean;
    function  GetMemo : TMemo;
    function  GetShowProgressOnMemo : boolean;
    procedure SetSourceFile(value : string);
    procedure SetTargetFile(value : string);
    procedure SetIncludeSubFolders(value : boolean);
    procedure SetMemo(value : TMemo);
    procedure SetShowProgressOnMemo(value : boolean);
    procedure ErrorMsg(s : string);
    procedure DoShowProgressOnMemo(s : string);
    function  ExecItem(source_path,target_path : string) : boolean;
    function  Execute(source_path,target_path : string) : boolean;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure ExecCopy;
    constructor Create(AOw: TComponent); override;
  published
    { Published declarations }
    // ************    EVENTS   ***********
    property OnCopyProgress : TCopyProgressEvent read FOnCopyProgress
              write FOnCopyProgress;
    property OnOverriding : TOnOverriding read FOnOverriding
             write FOnOverriding;
    property OnError : TOnError read FOnError
             write FOnError;
    property SourceFile : string read FSourceFile write SetSourceFile;
    property TargetFile : string read FTargetFile write SetTargetFile;
    property IncludeSubFolders : boolean read GetIncludeSubFolders
                    write SetIncludeSubFolders default false;
    property Memo : TMemo read GetMemo write SetMemo;
    property ShowProgressOnMemo : boolean read GetShowProgressOnMemo
                    write SetShowProgressOnMemo default true;
  end;

procedure Register;


implementation



procedure Register;
begin
  RegisterComponents('System', [TFileCopyNew]);
end;

constructor TFileCopyNew.Create(AOw: TComponent);
begin
   inherited Create(AOw);
   FSourceFile := '';
   FTargetFile := '';
   FIncludeSubFolders := false;
   FMemo              := nil;
   FShowProgressOnMemo := true;
end;


procedure TFileCopyNew.DoShowProgressOnMemo(s : string);
begin
   if not FShowProgressOnMemo then exit;
   if not assigned(memo) then
   begin
      ErrorMsg('Error : you must assign an exsisting TMemo to memo property,' +
                chr(13) + 'before setting ShowProgressOnMemo = True');
      exit;
   end;
   memo.lines.add(s);
end;

function  TFileCopyNew.GetIncludeSubFolders : boolean;
begin
   result := FIncludeSubFolders;
end;

function  TFileCopyNew.GetMemo : TMemo;
begin
   result := FMemo;
end;

function  TFileCopyNew.GetShowProgressOnMemo : boolean;
begin
   result := FShowProgressOnMemo;
end;

procedure TFileCopyNew.SetSourceFile(value : string);
begin
   if value <> FSourceFile then FSourceFile := Value;
end;

procedure TFileCopyNew.SetTargetFile(value : string);
begin
   if value <> FTargetFile then FTargetFile := Value;
end;

procedure TFileCopyNew.SetIncludeSubFolders(value : boolean);
begin
   if value <> FIncludeSubFolders then FIncludeSubFolders := value;
end;

procedure TFileCopyNew.SetMemo(value : TMemo);
begin
   FMemo := value;
end;

procedure TFileCopyNew.SetShowProgressOnMemo(value : boolean);
begin
   if value <> FShowProgressOnMemo then FShowProgressOnMemo := value;
end;

procedure TFileCopyNew.ErrorMsg(s : string);
begin
   // raises the event
   if assigned(FOnError) then
      FOnError(self, s);
end;



function  TFileCopyNew.ExecItem(source_path,target_path : string) : boolean;
var
  SourSize          : LongInt;
  nBlocchi          : real;
  pCentRate         : real;
  rRead, rWrite     : real;
  pCentRead         : integer;  // read blocks % for the OnCopyProgress event
  pCentWritten      : integer;  // written blocks % for the OnCopyProgress event
  sour              : tFileRec;
  targ              : tFileRec;
  nLetti,nScritti   : integer;
  oldCursor         : hCursor;
  canOverride : boolean;
begin
   result := false;
   // if source file and target file are identical raises an error
    if source_path = target_path then
    begin
       ErrorMsg('Error !!!' + chr(13) +
                  'I can''t copy ' + source_path + ' on itself');
      exit;
    end;
    new(FBuf);

    // tries to open the source file
    Sour.handle := fileOpen(source_path, fmOpenRead);

    // compute how many block are needed
    SourSize := fileSeek(Sour.handle, 0, 2);
    if SourSize < 0 then
    begin
       MessageBeep(0);
       ErrorMsg(source_path + ' missing or corrupted or opened for exclusive use');
       dispose(FBuf);
       exit;
    end;

    // set the handle to the file beginning
    fileSeek(Sour.handle, 0, 0);
    nBlocchi := SourSize*1.0 / BlockSize;
    // compute the percentage rate for each block
    pCentRate := 100.0 / nBlocchi;
    // set to zero read/written blocks percentage
    rRead      := 0;
    rWrite     := 0;
    pCentRead  := 0;
    pCentWritten := 0;

    if FileExists(target_path) then
    begin
       // default doesn't override an existing file
      canOverride := false;
      if assigned(FOnOverriding) then
         FOnOverriding(self, canOverride);  // ask user
    end
    else canOverride := true;

    if not canOverride then
    begin
       FileClose(Sour.Handle);
       dispose(FBuf);
       exit;
    end;

    // tries to create the target file
    Targ.handle := FileCreate(target_path);
    if targ.handle < 0 then
    begin
       FileClose(Sour.Handle);
       dispose(FBuf);
       ErrorMsg('Error on creating ' + target_path);
       exit;
    end;

    // copy block
    repeat
      // reading
      nLetti := FileRead(Sour.Handle,FBuf^, sizeOf(FBuf^));
      if nLetti < 0 then
      begin
         FileClose(Sour.Handle);
         FileClose(Targ.handle);
         dispose(FBuf);
         ErrorMsg('Read error on ' + chr(13) + source_path
              + chr(13) + 'Copy failed.');
         exit;
      end;
      rRead := rRead + pCentRate;
      pCentRead := trunc(rRead);
      // raises event
      if Assigned(FOnCopyProgress) then FOnCopyProgress(Self,pCentRead,pCentWritten);

      // writing
      nScritti := FileWrite(Targ.Handle, FBuf^, nLetti);
      if nScritti < 0 then
      begin
         FileClose(Sour.Handle);
         FileClose(Targ.handle);
         dispose(FBuf);
         ErrorMsg('Write error on ' + chr(13) + target_path
           + chr(13) + 'Copy failed.');
         exit;
      end;
      rWrite := rWrite + pCentRate;
      pCentWritten := trunc(rWrite);
      // raises event
      if Assigned(FOnCopyProgress) then FOnCopyProgress(Self,pCentRead,pCentWritten);
    until (nLetti = 0) or (nScritti <> nLetti);

    FileClose(Sour.Handle);
    FileClose(Targ.handle);
    dispose(FBuf);
    if Assigned(FOnCopyProgress) then FOnCopyProgress(Self,100,100);
    result := true;
end;

function TFileCopyNew.Execute(source_path,target_path : string) : boolean;
var
   searchRec  : TSearchRec;
   found      : integer;
   ok         : boolean;
   itemOk     : boolean;
   sFName,tFName : string;
   sPath, tPath  : string;
   extension     : string;

   function AdjustTargetFName(tFName : string) : string;
   begin
      if copy(tPath,length(tPath),1) <> '\' then tPath := tPath + '\';
      result := tPath + tFName;
   end;

begin
   if pos('*',source_path) = 0 then
   begin
      Ok := ExecItem(source_path,target_path);
      with FMemo do
      begin
         if assigned(FMemo) then
         begin
            if Ok then
                FMemo.lines.add('Ok - ' + source_path)
            else
                FMemo.lines.add('failed - ' + source_path);
         end;
      end;
   end
   else
   begin
      Ok := true;
      extension := extractFileName(source_path);
      Found := FindFirst(source_path, faAnyFile, SearchRec);
      while Found = 0 do
      begin
         with SearchRec do
         begin
            sPath  := extractFilePath(source_path);
            tPath  := extractFilePath(target_path);
            sFName := sPath + SearchRec.name;
            tFName := AdjustTargetFName(SearchRec.name);
            // if doesn't exists, create the target folder
            if not directoryExists(tPath) then
               ForceDirectories(tPath);
            case attr of
               faDirectory : begin
                                if (name='.') or (name='..') then
                                begin
                                   Found := FindNext(SearchRec);
                                   continue;
                                end
                                else
                                begin
                                   if IncludeSubFolders then
                                   begin
                                      // subfolders recursion check
                                      if pos(sPath, tPath) > 0 then
                                      begin
                                         FindClose(SearchRec.findHandle);
                                         ErrorMsg('ERROR : folder recursion'
                                             + chr(13) + chr(13) +
                                             'Can''t copy !');
                                         result := false;
                                         exit;
                                      end;
                                      if not directoryExists(tFName) then
                                             ForceDirectories(tFName);
                                      // *** recursion start ***
                                      Execute(sFName + '\' + extension,
                                              tFName + '\');
                                   end;
                                end;
                             end;

               faVolumeID  : begin
                                Found := FindNext(SearchRec);
                                continue;
                             end;
               else
               begin
                  itemOk := ExecItem(sFName, tFName);
                  if not itemOk then
                  begin
                     Ok := false;
                     FindClose(SearchRec.findHandle);
                     DoShowProgressOnMemo('failed - ' + sFName);
                  end
                  else
                     DoShowProgressOnMemo('Ok - ' + sFName);
               end;
            end;
         end;
         Found := FindNext(SearchRec);
      end;
      FindClose(SearchRec.findHandle);
   end;
   result := Ok;
end;

procedure TFileCopyNew.ExecCopy;
begin
   if FSourceFile = '' then
   begin
      ErrorMsg('I can''t copy' + chr(13) +
                  'Source File name missing');
      exit;
   end;
   if FTargetFile = '' then
   begin
      ErrorMsg('I can''t copy' + chr(13) +
                  'Target File name missing');
      exit;
   end;
   if not Execute(SourceFile,TargetFile) then
     ErrorMsg('Execution failed :' + chr(13) + chr(13) +
                  SourceFile + ' -> ' + TargetFile);
end;


end.
