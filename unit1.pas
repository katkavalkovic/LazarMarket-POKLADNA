unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    StornoBtn: TButton;
    OvocieBtn: TButton;
    PecivoBtn: TButton;
    OstatneBtn: TButton;
    VyhladajBtn: TButton;
    VlozBtn: TButton;
    PrejstKPlatbeBtn: TButton;
    OdhlasitBtn: TButton;
    LogInBtn: TButton;
    ZaplatitBtn: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure OdhlasitBtnClick(Sender: TObject);
    procedure LogInBtnClick(Sender: TObject);
    procedure PrejstKPlatbeBtnClick(Sender: TObject);
    procedure OvocieBtnClick(Sender: TObject);
    procedure StornoBtnClick(Sender: TObject);
    procedure ZaplatitBtnClick(Sender: TObject);
    procedure ZeleninaBtnClick(Sender: TObject);
    procedure VyhladajBtnClick(Sender: TObject);
    procedure VlozBtnClick(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Prihlasenie;
    procedure SchovajObjekty;
    procedure Nakup;

  private
    { private declarations }
  public
    { public declarations }
  end;

type zoznamTovaru=record
     kod: integer;
     nazov: string;
     nakupnacena: integer;
     predajnacena: integer;
     pocet: integer;
end;

type zoznamPokladnikov=record
     meno: string;
     kod: string;
end;

type zoznamOvocia=record
     kod: integer;
     nazov: string;
     nakupnacena: integer;
     predajnacena: integer;
     pocet: integer;
end;

type zoznamUctenka=record
     kod: integer;
     nazov: string;
     pocet: integer;
     cena: integer;
end;

const n=6;
      m=10;
      o=5;
      p=50;

var
  pokladnici: array[1..n] of zoznampokladnikov;
  tovar: array[1..m] of zoznamtovaru;
  sklad: array[1..2,1..m] of integer;
  ovocie: array[1..o] of zoznamovocia;
  uctenka: array[1..p] of zoznamuctenka;
  //subory: array of textfile;
  i, itemindex, kodtovaru, pocetobjektov, celkom, q: integer;
  subor1, subor2, subor3, subor4, subor5: textfile;
  znak: char;
  kod, pokladnik: string;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Prihlasenie;     //procedura
var
  k: boolean;
begin
kod:=edit1.text;
k:=false;
for i:=1 to n do
    begin
    if pokladnici[i].kod = kod then
       begin
         pokladnik:=pokladnici[i].meno;
         label3.caption:='Pokladnu obsluhuje: '+pokladnik;
         //NakupBtn.visible:=true;
         Edit1.visible:=false;
         LogInBtn.visible:=false;
         Label1.visible:=false;
         k:=true;
         nakup;
         break;   //tento hnusny break
       end;
    end;

if k=false then
   ShowMessage('Nesprávny kód.');
end;

procedure TForm1.Nakup; //procedura namiesto buttonu
begin
for i:=1 to pocetobjektov do
                             begin
                               uctenka[i].kod:=0;
                               uctenka[i].nazov:=' ';
                               uctenka[i].pocet:=0;
                               uctenka[i].cena:=0;
                             end;
celkom:=0;
pocetobjektov:=0;
listbox1.Items.clear;
listbox2.items.clear;

image1.visible:=true;
listbox1.visible:=true;
listbox2.visible:=true;
label1.visible:=false;
label2.visible:=false;
label3.visible:=true;
label4.visible:=true;
label5.visible:=true;
Label6.visible:=false;
OvocieBtn.visible:=true;
PecivoBtn.visible:=true;
OstatneBtn.visible:=true;
VyhladajBtn.visible:=true;
ZaplatitBtn.visible:=false;
OdhlasitBtn.visible:=true;
VlozBtn.visible:=true;
LogInBtn.visible:=false;
StornoBtn.visible:=true;
PrejstKPlatbeBtn.visible:=true;
edit1.visible:=false;
edit2.visible:=true;
edit3.visible:=true;
memo1.Visible:=false;

end;

procedure TForm1.LogInBtnClick(Sender: TObject);
begin
Prihlasenie;
end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
begin
Prihlasenie;
end;

procedure TForm1.SchovajObjekty;  //tato procedura nebude potrebna ak bude viac formov
begin
image1.visible:=false;
label2.visible:=false;
label3.visible:=false;
label4.visible:=false;
label5.visible:=false;
Label6.visible:=false;
OvocieBtn.visible:=false;
PecivoBtn.visible:=false;
OstatneBtn.visible:=false;
VyhladajBtn.visible:=false;
VlozBtn.visible:=false;
PrejstKPlatbeBtn.visible:=false;
StornoBtn.visible:=false;
//NakupBtn.visible:=false;
OdhlasitBtn.visible:=false;
ZaplatitBtn.visible:=false;
edit2.visible:=false;
edit3.visible:=false;
listbox1.Visible:=false;
listbox2.visible:=false;
memo1.Visible:=false;
end;

procedure TForm1.VyhladajBtnClick(Sender: TObject);
begin
//co keby teraz vybehlo memo s nazvom tovaru a uz nan nemusim klikat, ved som ho uz vybral <=== presne takto som to mal v plane
//vypise to aj do Labelu kde je nazov tovaru
//vyhlada tovar v zozname tovaru a zisti jeho index, zaznamena ho
//globalna premenna index bude pouzita do VLOZ
   ListBox1.Items.Clear;
   kodTovaru:=strtoint(Edit3.Text);
   for i:=1 to m do
      if kodTovaru = tovar[i].kod then
         begin
           Label2.Caption:= tovar[i].nazov;
           Label2.Visible:= True;
           itemIndex:= i - 1;
           //-1 preto, lebo v procedure VlozBtnClick je z nejakeho dovodu: "itemIndex = itemIndex + 1;"
           //a nechcel som do toho rypat, ale mali by sme to odstranit asi
         end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
hold,j,x2,x3,x4,kod,nakupnacena,predajnacena,pocet: integer;    //x je premenna na pocet riadkov v txt subore
begin
q:=0; //premenna na poradove cislo uctenky
ListBox1.Items.Clear;
ListBox2.Items.Clear;
image1.picture.loadfromfile('logo.png');
Label6.Caption:='Košík';
SchovajObjekty;  //vsetky az na label1,edit1 a LogInBtn
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

     //memo2.append(pokladnici[i].meno+pokladnici[i].kod);
     readln(subor1);
end;

assignfile(subor2,'TOVAR.txt');
reset(subor2);
i:=0;
readln(subor2,x2);
while not eof(subor2) do
begin
     inc(i);
     read(subor2,tovar[i].kod);
     read(subor2,znak);  //precitaj medzeru
     readln(subor2,tovar[i].nazov);  //precita cely string po koniec a skoci na dalsi riadok
     //memo1.append(inttostr(tovar[i].kod)+tovar[i].nazov);
end;
closefile(subor2);

assignfile(subor3,'CENNIK.txt');
reset(subor3);
i:=0;
readln(subor3,x3);
while not eof(subor3) do
begin
     inc(i);
     read(subor3,kod);
     read(subor3,nakupnacena);
     read(subor3,predajnacena);
     for j:=1 to m do
         if tovar[j].kod=kod then
            begin
                 tovar[j].nakupnacena:=nakupnacena;
                 tovar[j].predajnacena:=predajnacena;
            end;
end;
closefile(subor3);


assignfile(subor4,'SKLAD.txt');
reset(subor4);
i:=0;
readln(subor4,x4);
while not eof(subor4) do
begin
     inc(i);
     read(subor4,kod);
     read(subor4,pocet);
     for j:=1 to m do
         if tovar[j].kod=kod then tovar[j].pocet:=pocet;
     //memo1.append(inttostr(tovar[i].kod)+tovar[i].nazov+inttostr(tovar[i].nakupnacena)+inttostr(tovar[i].predajnacena)+inttostr(tovar[i].pocet));
end;

end;

procedure TForm1.PrejstKPlatbeBtnClick(Sender: TObject);
begin
SchovajObjekty;
memo1.clear;
label6.visible:=true;
memo1.visible:=true;
ZaplatitBtn.visible:=true;
memo1.append('                                                                                          Lazarmarket');
memo1.append('Obsluhuje Vas: '+pokladnik);
memo1.append(' ');
for i:=1 to pocetobjektov do
    (memo1.append(inttostr(uctenka[i].kod)+'  '+uctenka[i].nazov+'         '+inttostr(uctenka[i].pocet)+'x'+inttostr(uctenka[i].cena)+'€'+'    '+inttostr(uctenka[i].pocet*uctenka[i].cena)+'€'));
memo1.append(' ');
memo1.append('---------------------------');
memo1.append(inttostr(celkom)+' €');
end;

procedure TForm1.OvocieBtnClick(Sender: TObject);
begin
ListBox1.Items.Clear;
for i:=1 to m do
    ListBox1.Items.Add(tovar[i].nazov);
end;

procedure TForm1.StornoBtnClick(Sender: TObject);
var
  stornoIndex, i: integer;
begin

     case QuestionDlg ('STORNO','Chcete stornovať celý nákup alebo zvolenú položku?',mtCustom,[mrYes,'Nákup', mrNo , 'Položku', 'IsDefault'],'') of
        mrYes: if PasswordBox( 'STORNO' , 'Zadajte váš kód:' ) = kod  then
           begin
             SchovajObjekty;
             //NakupBtn.visible:=true;
             listbox1.Items.clear;
             listbox2.items.clear;
             Nakup;
             for i:=1 to pocetobjektov do
                 begin
                   uctenka[i].kod:=0;
                   uctenka[i].nazov:=' ';
                   uctenka[i].pocet:=0;
                   uctenka[i].cena:=0;
                 end;
           end
        else ShowMessage('Nesprávny kód.');
        mrNo:  if PasswordBox( 'STORNO' , 'Zadajte váš kód:' ) =  kod  then
                  begin
                    for i := 0 to (ListBox2.Count - 1) do
                        if ListBox2.Selected[ i ] = True then
                           stornoIndex := i;

                    Listbox2.Items.Delete(stornoIndex);
                    stornoindex:=stornoindex+1;
                    celkom:=celkom-(uctenka[stornoindex].cena*uctenka[stornoindex].pocet);
                    if stornoindex=pocetobjektov then
                       begin
                    uctenka[stornoindex].kod:=0;
                    uctenka[stornoindex].nazov:=' ';
                    uctenka[stornoindex].cena:=0;
                    uctenka[stornoindex].pocet:=0;
                    dec(pocetobjektov);
                       end
                    else
                        begin
                             for i:=stornoindex to pocetobjektov do
                                 uctenka[i]:=uctenka[i+1];
                             dec(pocetobjektov);
                        end;
                  end
               else ShowMessage('Nesprávny kód.');
        mrCancel: ;
     end;

end;

procedure TForm1.ZaplatitBtnClick(Sender: TObject);
begin
SchovajObjekty;
//NakupBtn.visible:=true;
inc(q);
assignfile(subor5,'uctenka'+inttostr(q)+'.txt');
rewrite(subor5);
writeln(subor5,'                                                                                 Lazarmarket');
writeln(subor5,'Obsluhuje Vas: '+pokladnik);
writeln(subor5);
for i:=1 to pocetobjektov do
    (writeln(subor5,inttostr(uctenka[i].kod)+'  '+uctenka[i].nazov+'         '+inttostr(uctenka[i].pocet)+'x'+inttostr(uctenka[i].cena)+'€'+'    '+inttostr(uctenka[i].pocet*uctenka[i].cena)+'€'));
writeln(subor5);
writeln(subor5,'---------------------------');
writeln(subor5,inttostr(celkom)+' €');
closefile(subor5);
Nakup;
end;

procedure TForm1.ZeleninaBtnClick(Sender: TObject);
begin

end;

procedure TForm1.VlozBtnClick(Sender: TObject);  //dve moznosti: vloz ak je to list objektov alebo je vyhladany podla kodu
var
pocet: integer;
begin
     pocet:= strtoint( edit2.text );
     if pocet > 0 then
        begin
             itemindex:= itemindex+1;
             inc( pocetobjektov );
        //memo2.append('pocet objektov '+inttostr(pocetobjektov));
             Listbox2.Items.Add( inttostr( tovar[ itemindex ].kod ) + '  ' + tovar[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + inttostr( tovar[ itemindex ].predajnacena ) + '€' + '    ' + inttostr( pocet*tovar[ itemindex ].predajnacena ) + '€' );
             uctenka[ pocetobjektov ].kod:= tovar[ itemindex ].kod;
             uctenka[ pocetobjektov ].nazov:= tovar[ itemindex ].nazov;
             uctenka[ pocetobjektov ].cena:= tovar[ itemindex ].predajnacena;
             uctenka[ pocetobjektov ].pocet:= pocet;
        //memo2.append(inttostr(uctenka[pocetobjektov].kod)+'  '+uctenka[pocetobjektov].nazov+'         '+inttostr(uctenka[pocetobjektov].pocet)+'x'+inttostr(uctenka[pocetobjektov].cena)+'€'+'    '+inttostr(uctenka[pocetobjektov].pocet*uctenka[pocetobjektov].cena)+'€');
             celkom:= celkom + ( uctenka[ pocetobjektov ].pocet*uctenka[ pocetobjektov ].cena );
             edit2.clear;
        end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var i: integer;
begin
for i:= 0 to ListBox1.Count-1 do
    if ListBox1.Selected[ i ] = True then
       begin
            itemIndex:= i;
            Break;
       end;
Label2.Caption:= (ListBox1.Items[itemIndex]);
Label2.Visible:= True;
end;

procedure TForm1.OdhlasitBtnClick(Sender: TObject);
begin
     SchovajObjekty;
     Label1.Visible:= True;
     Edit1.Visible:= True;
     Loginbtn.Visible:= True;
     Edit1.Caption:= '';
end;

end.

