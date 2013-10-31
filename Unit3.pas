unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, inifiles, registry, 
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Grids, UrlHistory;

type
  TForm3 = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Label1: TLabel;
    UrlHistory1: TUrlHistory;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  PopupHedefGercekKlasor:String;
  islem:boolean;
  InstanceNum:Integer;
  islemsay:Integer;
  FavoriEkle : boolean;
  favoriURL,favoriBaslik,favoriNot : String;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm3.FormCreate(Sender: TObject);
var
 i,j,total,totalson:Integer;
begin
 TreeView1.Items := Form1.TreeView1.Items;
 TreeView1.FullExpand;
 TreeView1.Selected := TreeView1.Items.GetFirstNode;
 PopupHedefGercekKlasor := '';

 InstanceNum := 0;
 islemsay:=0;
 favoriURL := '';
 favoriBaslik := '';
 favoriNot := '';

 if FavoriEkle then
 begin
  Width :=  355;
  StringGrid1.Cells[0, 0] := 'Last Visited';
  StringGrid1.ColWidths[0]:= 80;
  StringGrid1.Cells[1, 0] := 'Title';
  StringGrid1.ColWidths[1]:= 120;
  StringGrid1.Cells[2, 0] := 'Url';
  StringGrid1.ColWidths[2]:= 120;
  StringGrid1.DefaultRowHeight := 18;
  With Urlhistory1 do
  begin
   SortField:=sfLastvisited;
   j:=-1;
   total := UrlHistory1.Enumerate;
   totalson := total-75;
   if totalson<0 then totalson := 0;
   For i:= Total-1 downto totalson do
   begin
    if pos('HTTP',uppercase(PEntry(Urlhistory1.Items[i]).Url))=1 then
    begin
     inc(j);
     StringGrid1.RowCount := j+2;
     Stringgrid1.Cells[0, j+1] := DateTimeToStr(PEntry(Urlhistory1.Items[i]).LastVisited);
     Stringgrid1.Cells[1, j+1] := PEntry(Urlhistory1.Items[i]).Title;
     Stringgrid1.Cells[2, j+1] := PEntry(Urlhistory1.Items[i]).Url;
    end;
   end;
  end;

  Panel2.Visible := TRUE;
  Caption := 'Add Favorite';
  BitBtn1.Caption := '&Done';
 end else
 begin
  Caption := 'Move To Folder';
  Panel2.Visible := FALSE;
  BitBtn1.Caption := '&Select';
 end;
end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin
 CLOSE;
end;

procedure TForm3.BitBtn1Click(Sender: TObject);
var
 bosluk,s,kategoridongu,aranan : string;
 RootNode : TTreeNode;
 i,j,k,j1 : integer;
 Reg: TIniFile;
begin
 PopupHedefGercekKlasor := initDir;

 RootNode := TreeView1.Selected;
 repeat
  kategoridongu := RootNode.Text+'\'+kategoridongu;
  RootNode := RootNode.Parent;
 until RootNode = nil;

 s := kategoridongu;
 delete(s,1,pos('\',s)-1);
 PopupHedefGercekKlasor := PopupHedefGercekKlasor + s;
 if PopupHedefGercekKlasor[length(PopupHedefGercekKlasor)]='\' then delete(PopupHedefGercekKlasor,length(PopupHedefGercekKlasor),1);

 if MessageDlg('Are you sure you want to add ('+StringGrid1.Cells[1, StringGrid1.row ]+' '+StringGrid1.Cells[2, StringGrid1.row ]+
               ') to the '+kategoridongu+' folder?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  favoriURL := StringGrid1.Cells[2, StringGrid1.row ];
  favoriBaslik := StringGrid1.Cells[1, StringGrid1.row ];
  CLOSE;
 end;

end;

end.
