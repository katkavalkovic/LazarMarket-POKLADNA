unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    StornoBtn: TButton;
    OvocieBtn: TButton;
    ZeleninaBtn: TButton;
    PecivoBtn: TButton;
    OstatneBtn: TButton;
    Button6: TButton;
    VlozBtn: TButton;
    Button8: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure OvocieBtnClick(Sender: TObject);
    procedure StornoBtnClick(Sender: TObject);
    procedure ZeleninaBtnClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure VlozBtnClick(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Vyhladajpodlakodu;
    procedure Prihlasenie;
  private
    { private declarations }
  public
    { public declarations }
  end;

type zoznam2=record
     kod: integer;
     nazov: string;
     cena: integer;
     pocet: integer;
end;

type zoznam1=record
     meno: string;
     kod: string;
end;

const n=6;
      m=2;

var
  pokladnici: array[1..n] of zoznam1;
  ovocie: array[1..m] of zoznam2;
  i, itemindex, kodtovaru: integer;
  subor1, subor2, uctenka: textfile;
  znak: char;
  kod, pokladnik: string;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Prihlasenie;
begin
kod:=edit1.Text;
for i:=1 to n do                           //tu asi treba zmenit cyklus
    if pokladnici[i].kod = kod then begin
       pokladnik:=pokladnici[i].meno;
       label3.caption:='Pokladnu obsluhuje: '+pokladnik;
       image1.visible:=true;
       listbox1.visible:=true;
       label2.visible:=false;
       label3.visible:=true;
       label4.visible:=true;
       label5.visible:=true;
       OvocieBtn.visible:=true;
       ZeleninaBtn.visible:=true;
       PecivoBtn.visible:=true;
       OstatneBtn.visible:=true;
       button6.visible:=true;
       VlozBtn.visible:=true;
       button8.visible:=true;
       edit2.visible:=true;
       edit3.visible:=true;
       listbox2.visible:=true;
       label1.visible:=false;
       edit1.visible:=false;
       button1.visible:=false;
    end;
end;

procedure TForm1.VyhladajPodlaKodu;
begin
ListBox1.Items.Clear;
kodtovaru:=strtoint(edit3.text);
for i:=1 to m do
    if kodtovaru=ovocie[i].kod then
       ListBox1.Items.Add(ovocie[i].nazov);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
prihlasenie();
end;

procedure TForm1.OvocieBtnClick(Sender: TObject);
begin
ListBox1.Items.Clear;
for i:=1 to m do
    ListBox1.Items.Add(ovocie[i].nazov);
end;

procedure TForm1.StornoBtnClick(Sender: TObject);
var
  stornoIndex, i: integer;
begin

     case QuestionDlg ('STORNO','Chcete stornovať celý nákup, zvolenú položku?',mtCustom,[mrYes,'Nákup', mrNo , 'Položku', 'IsDefault'],'') of
        mrYes: if PasswordBox( 'STORNO' , 'Zadajte váš kód:' ) = kod  then Close else ShowMessage('Nesprávny kód.');
        mrNo:  if PasswordBox( 'STORNO' , 'Zadajte váš kód:' ) =  kod  then
                  begin
                    for i := 0 to (ListBox2.Count - 1) do
                        if ListBox2.Selected[ i ] = True then
                           stornoIndex := i;

                    Listbox2.Items.Delete(stornoIndex);
                  end
               else ShowMessage('Nesprávny kód.');
        mrCancel: ;
     end;

end;

procedure TForm1.ZeleninaBtnClick(Sender: TObject);
begin

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
vyhladajpodlakodu;
end;

procedure TForm1.VlozBtnClick(Sender: TObject);
begin
itemindex:=itemindex+1;


Listbox2.Items.Add(ovocie[itemindex].nazov);
end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
begin
prihlasenie;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  hold: integer;
begin
ListBox2.Items.Clear;
image1.picture.loadfromfile('logo.png');
image1.visible:=false;
label2.visible:=false;
label3.visible:=false;
label4.visible:=false;
label5.visible:=false;
OvocieBtn.visible:=false;
ZeleninaBtn.visible:=false;
PecivoBtn.visible:=false;
OstatneBtn.visible:=false;
button6.visible:=false;
VlozBtn.visible:=false;
button8.visible:=false;
edit2.visible:=false;
edit3.visible:=false;
listbox2.visible:=false;
listbox1.Visible:=false;

assignfile(subor1,'pokladnici.txt');
reset(subor1);
i:=0;
while not eof(subor1) do     //nacitanie mien a kodov pokladnikov
begin
     inc(i);
     read(subor1,znak);
     repeat
       pokladnici[i].meno:=pokladnici[i].meno+znak;
       read(subor1,znak);
     until znak = ' ';

     repeat
       read(subor1,znak);
       pokladnici[i].kod:=pokladnici[i].kod+znak;
     until eoLn(subor1);
     readln(subor1);
end;

assignfile(subor2,'ovocie.txt');
reset(subor2);
i:=0;
while not eof(subor2) do
begin
     inc(i);
     read(subor2,ovocie[i].kod);
     read(subor2,znak);
     read(subor2,znak);
     repeat
     ovocie[i].nazov:=ovocie[i].nazov+znak;
     read(subor2,znak);
     until znak=' ';
     read(subor2,ovocie[i].cena);
     read(subor2,ovocie[i].pocet);
     readln(subor1);
     ////memo1.append(inttostr(ovocie[i].kod)+ovocie[i].nazov+inttostr(ovocie[i].cena)+inttostr(ovocie[i].pocet));
end;

end;

procedure TForm1.Image2Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox1Click(Sender: TObject);
var i: integer;
begin
for i:= 0 to ListBox1.Count-1 do
    if ListBox1.Selected[i]=True then
       begin
            itemIndex:=i;
            break;
       end;
label2.caption:=(ListBox1.Items[itemIndex]);
label2.visible:=true;
end;

end.

