unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellApi, ComCtrls, AdvStatusBar, inifiles, registry, Buttons, ToolWin,
  ExtCtrls, Grids, BaseGrid, AdvGrid, raylightAutostart, Systray, Psock,
  NMHttp, Menus, URLLabel, IEDownload;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    AdvStatusBar1: TAdvStatusBar;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    Splitter2: TSplitter;
    SpeedButton2: TSpeedButton;
    AdvStringGrid1: TAdvStringGrid;
    Systray1: TSystray;
    RaylightAutostart1: TRaylightAutostart;
    PopupMenu1: TPopupMenu;
    Restore1: TMenuItem;
    UpdatemyFavoritesontheweb1: TMenuItem;
    Exit1: TMenuItem;
    ProgressBar1: TProgressBar;
    SpeedButton3: TSpeedButton;
    Image1: TImage;
    Label2: TLabel;
    SpeedButton4: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    URLLabel1: TURLLabel;
    Label5: TLabel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    SpeedButton5: TSpeedButton;
    Addfavorite1: TMenuItem;
    N1: TMenuItem;
    SpeedButton6: TSpeedButton;
    IEDownload1: TIEDownload;
    Timer1: TTimer;

    procedure FavoritBul;
    procedure FavoritYukle;
    procedure FillFavorites(Directory: string);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Systray1LeftClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton3Click(Sender: TObject);
    procedure AdvStringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure etkinUrlGoster;
    procedure EtkinKlasorGoster;
    procedure SpeedButton4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Restore1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  favorites : array[1..7000] of Record
                                 url     : String[255];
                                 baslik  : String[255];
                                 favicon : String[255];
                                 notes   : String[255];
                                 kokid   : integer;
                                end;
  maxFavorit : Integer;

  kokler     : array[1..500] of Record
                                 kokad : String;
                                 dalsay: integer;
                                 sayfa : integer;
                                 id    : integer;
                                end;
  maxKok     : integer;

  dalsay     : integer;
  kokid      : integer;
  kokidler   : array[0..150] of integer;
  appdir     : String;
  ProgramTamClose   : Boolean;
  sonucURL,sonucIcon,sonucBaslik,sonucNotes : String;
  gercekKlasor:String;
  InitDir : string;

implementation

uses Unit2, Unit3, Unit4;

{$R *.DFM}
procedure ReadUrl(AFileName: string);
var
 Reg: TIniFile;
begin
 Reg := TIniFile.Create(AFileName);
 sonucURL := Reg.ReadString('InternetShortcut', 'URL', 'no URL');
 sonucICON := Reg.ReadString('InternetShortcut', 'IconFile', '');
 sonucNotes := Reg.ReadString('izlenim', 'Notes', '');
 Reg.Free;
end;

procedure UpdateINIfile(AFileName,NewFileName,URL,Notes: string);
var
 Reg: TIniFile;
begin
 Reg := TIniFile.Create(AFileName);
 Reg.WriteString('InternetShortcut', 'URL', URL);
 Reg.WriteString('izlenim', 'Notes', Notes);
 Reg.Free;

 if AFileName<>NewFileName then
 begin
  RenameFile(AFileName,NewFileName);
 end;
end;

function PosRight(sub: char; s: string): integer;
var
 i : integer;
begin
 result := -1;
 for i := Length(s) downto 1 do
  if s[i] = sub then
  begin
   result := i;
   break;
  end;
end;

procedure TForm1.FillFavorites(Directory: string);
var
 tsearch : TSearchRec;
begin
 if Directory[length(Directory)] <> '\' then Directory := Directory + '\';
 if FindFirst(Directory + '*.*', faArchive + fadirectory, tsearch) = 0 then
 begin
  repeat
   if ((tsearch.Attr and fadirectory) = fadirectory) and (tsearch.name[1] <> '.') then
   begin
    inc(dalSay);
    inc(maxKok);
    kokler[maxKok].kokad  := tsearch.Name;
    kokler[maxKok].dalsay := dalSay;
    kokler[maxKok].id     := maxKok;
    kokidler[dalsay]      := maxKok;

    FillFavorites(Directory + tsearch.Name); //, Item);
   end else
   if ((tsearch.Attr and faArchive) = faArchive) then
   begin
    inc(maxFavorit);
    favorites[maxFavorit].baslik := copy(tsearch.Name,1,pos('.url',tsearch.Name)-1);
    ReadUrl(Directory + tsearch.Name);
    favorites[maxFavorit].url     := sonucURL;
    favorites[maxFavorit].favicon := sonucIcon;
    favorites[maxFavorit].notes   := sonucNotes;
    favorites[maxFavorit].kokid   := kokidler[dalsay];
   end;
// CreateMenuOption(Directory + search.Name, AMenuItem);
  until FindNext(tsearch) <> 0;
  FindClose(tsearch);
 end;
 dec(dalsay);
end;

procedure TForm1.FavoritBul;
var
 t       : TextFile;
 s,s1    : String;
 i,j,k   : integer;
begin
 MaxKok := 1;
 maxFavorit := 0;
 kokler[1].kokad := 'favorites';
 kokler[1].dalsay := 0;
 DalSay := 0;
 kokidler[dalsay] := 1;

 FillFavorites(InitDir);
 assignfile(t,appDir+'dir.txt');
 rewrite(t);

 for i := 1 to maxKok do
 begin
  s := '';
  if kokler[i].dalsay>0 then
  for j:=1 to kokler[i].dalsay do s:=s+' ';
  repeat k := pos(chr(9),kokler[i].kokad); if k<>0 then kokler[i].kokad[k] := ' '; until k=0;

  writeln(t,s+kokler[i].kokad+chr(9)+'('+inttostr(kokler[i].id)+')');
 end;
 closefile(t);

 assignfile(t,appDir+'url.txt');
 rewrite(t);

 for i := 1 to maxFavorit do
 begin
  s := '';
  repeat k := pos(chr(9),favorites[i].baslik); if k<>0 then favorites[i].baslik[k] := ' '; until k=0;
  repeat k := pos(chr(9),favorites[i].url); if k<>0 then favorites[i].url[k] := ' '; until k=0;
  repeat k := pos(chr(9),favorites[i].favicon); if k<>0 then favorites[i].favicon[k] := ' '; until k=0;
  repeat k := pos(chr(9),favorites[i].notes); if k<>0 then favorites[i].notes[k] := ' '; until k=0;

  writeln(t,favorites[i].baslik,chr(9),favorites[i].url,chr(9),favorites[i].notes,chr(9),favorites[i].favicon,chr(9),favorites[i].kokid);
 end;
 closefile(t);
end;

procedure TForm1.FavoritYukle;
var
 i,j,k    : integer;
 t        : textFile;
 s        : String;
 RootNode : TTreeNode;
begin
 if (fileexists(appDir+'dir.txt')) and (fileexists(appDir+'url.txt')) then
 begin
  maxFavorit := 0;
  maxKok     := 0;
  assignfile(t,appDir+'dir.txt');
  reset(t);
  repeat
   readln(t,s);
   inc(maxKok);
   kokler[maxKok].kokad := copy(s,1,pos(chr(9),s));
   delete(s,1,pos(chr(9)+'(',s)+1);
   kokler[maxKok].id := strtoint(copy(s,1,pos(')',s)-1));
  until eof(t);
  closefile(T);

  TreeView1.LoadFromFile(appDir+'dir.txt');
  for i := 1 to TreeView1.Items.Count do
   TreeView1.Items[i-1].Text := copy(TreeView1.Items[i-1].Text,1,pos(chr(9)+'(',TreeView1.Items[i-1].Text)-1);

  TreeView1.FullExpand;
  TreeView1.Selected := TreeView1.Items.GetFirstNode;

  assignfile(t,appDir+'url.txt');
  reset(t);
  repeat
   readln(t,s);
   inc(maxFavorit);

   favorites[maxFavorit].baslik := copy(s,1,pos(chr(9),s)-1);   delete(s,1,pos(chr(9),s));
   favorites[maxFavorit].url    := copy(s,1,pos(chr(9),s)-1);   delete(s,1,pos(chr(9),s));
   favorites[maxFavorit].notes  := copy(s,1,pos(chr(9),s)-1);   delete(s,1,pos(chr(9),s));
   favorites[maxFavorit].favicon:= copy(s,1,pos(chr(9),s)-1);   delete(s,1,pos(chr(9),s));
   favorites[maxFavorit].kokid  := strtoint(s);
  until eof(t);
  closefile(T);

 end;
 AdvStringGrid1.RowCount:=2;
 AdvStringGrid1.FixedRows:=1;

 AdvStringGrid1.ColWidths[0] := 0;
 AdvStringGrid1.ColWidths[1] := 20;
 AdvStringGrid1.ColWidths[2] := 160;
 AdvStringGrid1.ColWidths[3] := 100;
 AdvStringGrid1.ColWidths[4] := 45;

 AdvStringGrid1.Cells[0,0] := 'ID';
 AdvStringGrid1.Cells[1,0] := '';
 AdvStringGrid1.Cells[2,0] := 'Title';
 AdvStringGrid1.Cells[3,0] := 'URL';
 AdvStringGrid1.Cells[4,0] := 'Notes';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 Reg      : TRegistry;
 i        : integer;
begin
 Reg := TRegistry.Create;
 Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', false);
 InitDir := Reg.ReadString('Favorites');
 Reg.Free;
 gercekKlasor := initDir;

 ProgramTamClose := FALSE;
 appdir:=extractfiledir(application.exename)+'\';

{$I-}
 mkdir(appdir+'favicon');
 i:=ioResult;
{$I+}

 if (not fileexists(appDir+'dir.txt')) or (not fileexists(appDir+'url.txt')) then FavoritBul;
 FavoritYukle;
 EtkinKlasorGoster;
 EtkinUrlGoster;

 Edit1.Visible := FALSE;
 Edit2.Visible := FALSE;
 Edit3.Visible := FALSE;

 label4.Left    := 93;
 URLLabel1.Left := 93;
 Label5.Left    := 93;

 Edit1.Width       := Panel1.Width-100;
 Edit2.Width       := Panel1.Width-100;
 Edit3.Width       := Panel1.Width-100;

 label4.Width    := Panel1.Width-100;
 URLLabel1.Width := Panel1.Width-100;
 Label5.Width    := Panel1.Width-100;
 
// Image1.Picture.Icon.LoadFromFile(appdir+'favicon\http___images_v3_com_ico_v3logo_ico.ico');
end;

procedure TForm1.EtkinKlasorGoster;
var
 bosluk,s,kategoridongu,aranan : string;
 RootNode : TTreeNode;
 i,j,k,j1 : integer;

begin
 gercekKlasor := initDir;

 RootNode := TreeView1.Selected;
 repeat
  kategoridongu := RootNode.Text+'\'+kategoridongu;
  RootNode := RootNode.Parent;
 until RootNode = nil;

 s := kategoridongu;
 delete(s,1,pos('\',s)-1);
 gercekKlasor := gercekKlasor + s;
 if gercekKlasor[length(gercekKlasor)]='\' then delete(GercekKlasor,length(GercekKlasor),1);

 SpeedButton5.Enabled := TRUE;;
 if kategoridongu = 'favorites\' then SpeedButton5.Enabled := FALSE;

 AdvStatusBar1.Panels[0].Text := kategoridongu;
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

 k:=0;
 for j := 1 to maxFavorit do
  if favorites[j].kokid=i then
  begin
   inc(k);
   AdvStringGrid1.Cells[1,k] := '';
   AdvStringGrid1.Cells[2,k] := favorites[j].baslik;
   AdvStringGrid1.Cells[3,k] := favorites[j].url;
   AdvStringGrid1.Cells[4,k] := favorites[j].notes;

   s:=favorites[j].favicon;
   repeat j1 := pos(':',s); if j1<>0 then s[j1]:='_'; until j1=0;
   repeat j1 := pos('/',s); if j1<>0 then s[j1]:='_'; until j1=0;
   repeat j1 := pos('\',s); if j1<>0 then s[j1]:='_'; until j1=0;
   repeat j1 := pos('.',s); if j1<>0 then s[j1]:='_'; until j1=0;
   repeat j1 := pos('~',s); if j1<>0 then s[j1]:='_'; until j1=0;
   AdvStringGrid1.RemovePicture(1,k);

   if (fileexists(appdir+'favicon\'+s+'.bmp')) then
   begin
    try
     AdvStringGrid1.CreatePicture(1,k,True,StretchWithAspectRatio,3,haLeft,vaTop).LoadFromFile(appdir+'favicon\'+s+'.bmp');
     AdvStringGrid1.Cells[0,k] := s;
    except
    end;
   end else
   begin
    try
     if (fileexists(appdir+'favicon\internet.bmp')) then
     begin
      AdvStringGrid1.CreatePicture(1,k,True,StretchWithAspectRatio,3,haLeft,vaTop).LoadFromFile(appdir+'favicon\internet.bmp');
      AdvStringGrid1.Cells[0,k] := 'internet';
     end;
    except
    end;
   end;
  end;

  if k<1 then
  begin
   AdvStringGrid1.Cells[0,1] := '';
   if (fileexists(appdir+'favicon\internet.bmp')) then
    AdvStringGrid1.CreatePicture(1,1,True,StretchWithAspectRatio,3,haLeft,vaTop).LoadFromFile(appdir+'favicon\internet.bmp');
   AdvStringGrid1.Cells[0,1] := 'internet';
   AdvStringGrid1.Cells[2,1] := 'This folder is empty!';
   AdvStringGrid1.Cells[3,1] := '';
   AdvStringGrid1.Cells[4,1] := '';
   k:=1;
  end;

 AdvStringGrid1.RowCount:=k+1;
 AdvStringGrid1.Row := 1;
end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
 EtkinKlasorGoster;
 EtkinUrlGoster;
end;


procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 FavoritBul;
 FavoritYukle;
 EtkinKlasorGoster;
 EtkinUrlGoster;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 ProgramTamClose := TRUE;
 Close;
end;

procedure TForm1.Systray1LeftClick(Sender: TObject);
begin
 Application.Restore;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if not ProgramTamClose then
 begin
  Application.Minimize;
  Action := caNone;
 end;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
 i,j,k    : integer;
 s        : String;
 FIcon    : TIcon;
 FBmp     : TPicture;
 FStream  : TStream;

 Buff: array[0..255] of char;
begin
 form4.show;

 ProgressBar1.Min := 0;
 ProgressBar1.Max := maxFavorit;

 FIcon := TIcon.Create;
 FBmp  := TPicture.Create;

 for i := 1 to maxFavorit do
 begin
  ProgressBar1.Position := i;
  if favorites[i].favicon<>'' then
  begin
   s:=favorites[i].favicon;
   repeat j := pos(':',s); if j<>0 then s[j]:='_'; until j=0;
   repeat j := pos('/',s); if j<>0 then s[j]:='_'; until j=0;
   repeat j := pos('\',s); if j<>0 then s[j]:='_'; until j=0;
   repeat j := pos('.',s); if j<>0 then s[j]:='_'; until j=0;
   repeat j := pos('~',s); if j<>0 then s[j]:='_'; until j=0;
   if (not fileexists(appdir+'favicon\'+s+'.ico')) and (pos('HTTP://',uppercase(favorites[i].favicon))=1) then
   begin
    AdvStatusBar1.Panels[2].Text := favorites[i].favicon;

    try
     IEDownload1.Go(favorites[i].favicon,appdir+'favicon\'+s+'.ico');

     if FileExists(appdir+'favicon\'+s+'.bmp') then DeleteFile(appdir+'favicon\'+s+'.bmp');
     if FileExists(appdir+'favicon\'+s+'.ico') then
     try
      k := integer(extracticon(hInstance, StrPCopy(Buff, appdir+'favicon\'+s+'.ico'), cardinal(-1)));
      if k<>null then
      begin
       FIcon.Handle := extracticon(hInstance, StrPCopy(Buff, appdir+'favicon\'+s+'.ico'), 0);

       if not FIcon.Empty then
       begin
        FBmp.Bitmap.Height := FIcon.Height;
        FBmp.Bitmap.Width  := FIcon.Width;
        FBmp.Bitmap.Canvas.Draw(0,0,Ficon);
        FBmp.SaveToFile(appdir+'favicon\'+s+'.bmp');
       end;
      end;
     finally
     end;
    finally
    end;
   end;
  end;
 end;
 FIcon.Free;
 FBmp.Free;
end;


procedure TForm1.etkinUrlGoster;
var
 s:String;
 i,j,k:integer;
begin
 if FileExists(appdir+'favicon\'+AdvStringGrid1.Cells[0,AdvStringGrid1.GetRealRow]+'.bmp') then
  Image1.Picture.LoadFromFile(appdir+'favicon\'+AdvStringGrid1.Cells[0,AdvStringGrid1.GetRealRow]+'.bmp');

 Edit1.Text := AdvStringGrid1.Cells[2,AdvStringGrid1.GetRealRow];
 Edit2.Text := AdvStringGrid1.Cells[3,AdvStringGrid1.GetRealRow];
 Edit3.Text := AdvStringGrid1.Cells[4,AdvStringGrid1.GetRealRow];

 Edit1.Visible := FALSE;
 Edit2.Visible := FALSE;
 Edit3.Visible := FALSE;

 label4.Left    := 93;
 URLLabel1.Left := 93;
 Label5.Left    := 93;

 label4.Visible    := TRUE;
 URLLabel1.Visible := TRUE;
 Label5.Visible    := TRUE;

 Label4.Caption := AdvStringGrid1.Cells[2,AdvStringGrid1.GetRealRow];

 s := AdvStringGrid1.Cells[3,AdvStringGrid1.GetRealRow];
 delete(s,1,pos('http://',s)+6);
 URLLabel1.URL  := s;

 Label5.Caption := AdvStringGrid1.Cells[4,AdvStringGrid1.GetRealRow];

 BitBtn1.Enabled := FALSE;
 BitBtn2.Caption := '&Edit';
 BitBtn2.Enabled := TRUE;

end;


procedure TForm1.AdvStringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 EtkinURLGoster;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
 form2 := TForm2.create(Application);
 form2.showmodal;
 form2.free;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
 BitBtn1.Enabled := TRUE;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
 BitBtn1.Enabled := TRUE;
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
 BitBtn1.Enabled := TRUE;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
 t:TextFile;
 i:integer;
 s:String;
begin
 BitBtn1.Enabled := FALSE;
 UpdateINIfile(GercekKlasor+'\'+AdvStringGrid1.Cells[2,AdvStringGrid1.GetRealRow]+'.url',GercekKlasor+'\'+Edit1.Text+'.url',Edit2.Text,Edit3.Text);
 FavoritBul;
 FavoritYukle;
 EtkinKlasorGoster;
 EtkinUrlGoster;

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
 if BitBtn2.Caption = '&Cancel' then
 begin
  BitBtn2.Caption   := '&Edit';
  label4.Visible    := TRUE;
  URLLabel1.Visible := TRUE;
  Label5.Visible    := TRUE;

  Edit1.Visible     := FALSE;
  Edit2.Visible     := FALSE;
  Edit3.Visible     := FALSE;
 end else
 begin
  label4.Visible    := FALSE;
  URLLabel1.Visible := FALSE;
  Label5.Visible    := FALSE;

  Edit1.Visible     := TRUE;
  Edit2.Visible     := TRUE;
  Edit3.Visible     := TRUE;
  BitBtn2.Caption   := '&Cancel';
 end;

 Edit1.Width       := 517;
 Edit2.Width       := 517;
 Edit3.Width       := 517;

end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
 if MessageDlg('Are you sure you want to delete this favorite?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  if FileExists(GercekKlasor+'\'+AdvStringGrid1.Cells[2,AdvStringGrid1.GetRealRow]+'.url') then
   DeleteFile(GercekKlasor+'\'+AdvStringGrid1.Cells[2,AdvStringGrid1.GetRealRow]+'.url');

  FavoritBul;
  FavoritYukle;
  EtkinKlasorGoster;
  EtkinUrlGoster;
 end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
var
 i,j,k:integer;
begin
 favoriEkle := FALSE;
 form3 := TForm3.create(Application);
 form3.showmodal;
 form3.free;
 if PopupHedefGercekKlasor<>'' then
 begin
  if MessageDlg('Are you sure you want to move selected favorites to destination favorite?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   for i := AdvStringGrid1.selection.Top to AdvStringGrid1.selection.Bottom do
   begin
    if FileExists(GercekKlasor+'\'+AdvStringGrid1.Cells[2,i]+'.url') then
     RenameFile(GercekKlasor+'\'+AdvStringGrid1.Cells[2,i]+'.url',PopupHedefGercekKlasor+'\'+AdvStringGrid1.Cells[2,i]+'.url');
   end;
  end;
  FavoritBul;
  FavoritYukle;
  EtkinKlasorGoster;
  EtkinUrlGoster;
 end;
//  GercekKlasor+'\'+AdvStringGrid1.Cells[2,AdvStringGrid1.GetRealRow]+'.url';
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 ProgramTamClose := TRUE;
 Close;
end;

procedure TForm1.Restore1Click(Sender: TObject);
begin
 Application.Restore;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
 Edit1.Width       := Panel1.Width-100;
 Edit2.Width       := Panel1.Width-100;
 Edit3.Width       := Panel1.Width-100;

 label4.Width    := Panel1.Width-100;
 URLLabel1.Width := Panel1.Width-100;
 Label5.Width    := Panel1.Width-100;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
var
 Reg: TIniFile;
begin
 favoriEkle := TRUE;
 form3 := TForm3.create(Application);
 form3.showmodal;
 form3.free;

 if (favoriUrl<>'') and (favoriBaslik<>'') then
 begin
  Reg := TIniFile.Create(PopupHedefGercekKlasor+'\'+favoriBaslik+'.url');
  Reg.WriteString('InternetShortcut', 'URL', favoriUrl);
  Reg.WriteString('izlenim', 'Notes', '');
  Reg.Free;

  FavoritBul;
  FavoritYukle;
  EtkinKlasorGoster;
  EtkinUrlGoster;

 end;
end;

end.


(*
- klasör adlarýný deðiþtirebilme/silebilme ve taþýma ..........................................................................ok
- url adlarýný deðiþtirebilme/silebilme not ekleme ............................................................................ok
- kök yapýsýný bir txt dosyasýnýn içinde oluþtur her dala bir id ver ve bu idleri kullanarak içerdikleri sayfalarý bul ........ok
- kok.txt ve içerik.txt dosyalarýný sakla .....................................................................................ok
- yapý içinde dolaþým .........................................................................................................ok
- içerikler için faviconu çekme bölümünü yap ..................................................................................ok
- ico dosyasýný bmpye çevirme bölümü (birçok icon varsa birincisini çevirsin) .................................................ok
- toolbarda týklama ile açýlýp kapanacak bir yapý oluþtur .....................................................................ok
- manuel refresh ekle .........................................................................................................ok
- url baþka klasöre (çoklu) taþýma ............................................................................................ok
- url bandýndaki edit ve label alanlarýna geniþliðe göre limit koymak .........................................................ok
- etkin explorer penceresinin adresini ve titleni captur edebilme ve sadece aðaç yapýsýný göstererek insert edebilme yeteneði .ok
- kok ve içerik txt dosyalarýný saklamadan önce chr(9)larý space çevir ........................................................ok
- hatalý iconlarý saklamadan sil ve default iconu ienin iconuna çevir
- refresh iþlemini ve ikonlarý yükleme iþlemini birleþtir refreshte yapmadan önce sorsun veya inetdetect varsa denesin
- içerik içinde search iþlevini yap
- favorites klasöründe deðiþiklik olduðunda otomatik refresh yapsýn
- ayarlar ekraný
- program ilk çalýþtýrýldýðýnda dosyalar tekrar oluþturulsun
- açýlýþ ekraný ve help yaz
- shareware limiti koy

- otomatik nette güncelleme ekle
- serverde kendilerine hesap açma iþlevi koy (þifremi unuttum da olsun)
- izlenimin domaininde favorites bölümünde login olsun ve iki txt dosyasýný kullanarak veriler gelsin
- dosyalar izlenime bir asp ile upload edilsin
- þimdilik sadece ingilizce destekli olsun (ilerde unicode vb.)
- regite üye ol
- download.com vs. ekle
*)
