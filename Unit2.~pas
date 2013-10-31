unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ShellApi,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    TabSheet3: TTabSheet;
    Label6: TLabel;
    Button2: TButton;
    BitBtn1: TBitBtn;
    Label5: TLabel;
    Label7: TLabel;
    StatusBar1: TStatusBar;
    TabSheet4: TTabSheet;
    TreeView2: TTreeView;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TreeView2Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private
   HedefGercekKlasor:String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

function GetFolderDate(Folder: string): TDateTime;
var
  Rec: TSearchRec;
  Found: Integer;
  Date: TDateTime;
begin
  if Folder[Length(folder)] = '\' then
    Delete(Folder, Length(folder), 1);
  Result := 0;
  Found  := FindFirst(Folder, faDirectory, Rec);
  try
    if Found = 0 then
    begin
      Date   := FileDateToDateTime(Rec.Time);
      Result := Date;
    end;
  finally
    FindClose(Rec);
  end;
end;

function RenameDir(DirFrom, DirTo: string) : boolean;
var
  shellinfo: TSHFileOpStruct;
begin
  with shellinfo do
  begin
    Wnd    := 0;
    wFunc  := FO_RENAME;
    pFrom  := PChar(DirFrom);
    pTo    := PChar(DirTo);
    fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or
              FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  Result := (0 = SHFileOperation(shellinfo));
end;

function CopyDir(const fromDir, toDir: string): Boolean; 
var 
  fos: TSHFileOpStruct; 
begin 
  ZeroMemory(@fos, SizeOf(fos)); 
  with fos do 
  begin 
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0); 
    pTo    := PChar(toDir) 
  end; 
  Result := (0 = ShFileOperation(fos)); 
end; 


function MoveDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_MOVE;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function DelDir(dir: string): Boolean;
var
  fos: TSHFileOpStruct; 
begin 
  ZeroMemory(@fos, SizeOf(fos)); 
  with fos do 
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION; 
    pFrom  := PChar(dir + #0); 
  end; 
  Result := (0 = ShFileOperation(fos)); 
end; 


procedure TForm2.BitBtn2Click(Sender: TObject);
begin
 CLOSE;
end;

procedure TForm2.BitBtn3Click(Sender: TObject);
begin
 CLOSE;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
 bosluk,s,kategoridongu,aranan,ilkfolder : string;
 RootNode : TTreeNode;
 i,j,k,j1,bosluksay : integer;
 RootNodes : array[0..40] of TTreeNode;
 say,subfolders,favoriteSay : Integer;
 d: TDateTime;
begin
 subfolders := 0;
 favoriteSay  := 0;

 RootNode := Form1.TreeView1.Selected;
 repeat
  kategoridongu := RootNode.Text+'\'+kategoridongu;
  RootNode := RootNode.Parent;
 until RootNode = nil;
 s := kategoridongu;
 i:=0;
 bosluk:='';
 repeat
  aranan :=bosluk+copy(s,1,pos('\',s)-1)+chr(9);
  repeat
   inc(i);
  until (aranan=kokler[i].kokad) or (i=maxkok);
  delete(s,1,pos('\',s));
  bosluk := bosluk + ' ';
 until (s='') or (i=maxkok);

 s := kokler[i].kokad; bosluksay:=0; repeat if s[1]=' ' then begin inc(bosluksay); delete(s,1,1); end; until (bosluksay>=40) or (s='') or (s[1]<>' ');
 RootNodes[bosluksay] := TreeView1.Items.Add(nil,kokler[i].kokad);

 for say := 1 to maxFavorit do
  if favorites[say].kokid = i then inc(favoriteSay);
 ilkfolder := copy(kokler[i].kokad,1,pos(chr(9),kokler[i].kokad)-1);

 repeat
  inc(i);
  if pos(bosluk,kokler[i].kokad)=1 then
  begin
   s := kokler[i].kokad; bosluksay:=0; repeat if s[1]=' ' then begin inc(bosluksay); delete(s,1,1); end; until (bosluksay>=40) or (s='') or (s[1]<>' ');
   RootNodes[bosluksay] := TreeView1.Items.AddChild(RootNodes[bosluksay-1],kokler[i].kokad);
   inc(subfolders);

   for say := 1 to maxFavorit do
    if favorites[say].kokid = i then inc(favoriteSay);
  end;
 until (i>=maxkok) or (pos(bosluk,kokler[i].kokad)<>1);

 for i := 1 to TreeView1.Items.Count do
  TreeView1.Items[i-1].Text := copy(TreeView1.Items[i-1].Text,1,pos(chr(9),TreeView1.Items[i-1].Text)-1);

 TreeView1.FullExpand;
 TreeView1.Selected := TreeView1.Items.GetFirstNode;

 Label3.Caption := 'Folder Name: '+ilkfolder;
 Label2.Caption := 'Favorites: '+inttostr(favoriteSay);
 Label1.Caption := 'Sub Folders: '+inttostr(subfolders);

 HedefGercekKlasor:=GercekKlasor;
 d := GetFolderDate(gercekKlasor);
 Label5.Caption := 'Date Created: '+FormatDateTime('dddd, d. mmmm yyyy, hh:mm:ss', d);

 Label7.Caption := 'Physical Path: '+gercekKlasor;
 Label8.Caption := 'Source: '+gercekKlasor;
 repeat if ilkfolder[1]=' ' then delete(ilkfolder,1,1); until (ilkfolder='') or (ilkfolder[1]<>' ');
 Edit1.Text := ilkfolder;

 TreeView2.LoadFromFile(appDir+'dir.txt');
 for i := 1 to TreeView2.Items.Count do
  TreeView2.Items[i-1].Text := copy(TreeView2.Items[i-1].Text,1,pos(chr(9)+'(',TreeView2.Items[i-1].Text)-1);

 TreeView2.FullExpand;
 TreeView2.Selected := TreeView2.Items.GetFirstNode;

 if ilkfolder='favorites' then
 begin
  TabSheet2.Enabled := FALSE;
  TabSheet3.Enabled := FALSE;
  TabSheet4.Enabled := FALSE;
 end; 

end;



procedure TForm2.BitBtn4Click(Sender: TObject);
var
 S:String;
 i:integer;
begin
 s:=GercekKlasor;
 i := length(s)+1;
 repeat dec(i); until (s[i]='\') or (i=1);

 if s[i]='\' then
 begin
  delete(s,i+1,length(s)-i);
  if gercekKlasor<>s+edit1.text then
  begin
   if RenameFile(gercekKlasor, s+edit1.text) then
   begin
    form1.FavoritBul;
    form1.FavoritYukle;
    form1.EtkinKlasorGoster;
    form1.EtkinUrlGoster;
    close;
   end else MessageDlg('Unable to rename folder. Please check if the same folder already exists, if there are any sharing violations or the folder is read-only.', mtError, [mbOK], 0);
  end;
 end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 if MessageDlg('Are you sure you want to delete this folder and all its content?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  if DelDir(gercekKlasor) then
  begin
   form1.FavoritBul;
   form1.FavoritYukle;
   form1.EtkinKlasorGoster;
   form1.EtkinUrlGoster;
   close;
  end else MessageDlg('Unable to delete folder. Please check if there are any sharing violations or read-only files within.', mtError, [mbOK], 0);
 end;
end;

procedure TForm2.TreeView2Click(Sender: TObject);
var
 bosluk,s,kategoridongu,aranan : string;
 RootNode : TTreeNode;
 i,j,k,j1 : integer;
begin
 HedefGercekKlasor := initDir;

 RootNode := TreeView2.Selected;
 repeat
  kategoridongu := RootNode.Text+'\'+kategoridongu;
  RootNode := RootNode.Parent;
 until RootNode = nil;

 s := kategoridongu;
 delete(s,1,pos('\',s)-1);
 HedefgercekKlasor := HedefgercekKlasor + s;
 if HedefgercekKlasor[length(HedefgercekKlasor)]='\' then delete(HedefGercekKlasor,length(HedefGercekKlasor),1);
 Label9.caption := 'Target:'+hedefGercekKlasor;
end;

procedure TForm2.BitBtn6Click(Sender: TObject);
begin
 if MessageDlg('Are you sure you want to move source folder and all its content to selected Target folder?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  if (GercekKlasor<>HedefGercekKlasor) then
  begin
   if MoveDir(GercekKlasor,HedefGercekKlasor) then
   begin
    form1.FavoritBul;
    form1.FavoritYukle;
    form1.EtkinKlasorGoster;
    form1.EtkinUrlGoster;
    close;
   end else MessageDlg('Unable to move folder. Please check if there are any sharing violations or read-only files or folders within.', mtError, [mbOK], 0);
  end else MessageDlg('Source and Destination Folders can''t be the same.', mtError, [mbOK], 0);
 end; 
end;

end.
