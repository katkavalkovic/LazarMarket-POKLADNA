unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Math, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label7: TLabel;
    KontrolaSkladu: TTimer;
    KontrolaCenniku: TTimer;
    PrepisStatistiky: TTimer;
    KontrolaTovaru: TTimer;
    PrepisSklad: TTimer;
    Chyba1: TTimer;
    VsetokTovarBtn: TButton;
    MasoBtn: TButton;
    MrazeneBtn: TButton;
    ZeleninaBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    StornoBtn: TButton;
    OvocieBtn: TButton;
    PecivoBtn: TButton;
    DrogeriaBtn: TButton;
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
    procedure Chyba1Timer(Sender: TObject);
    procedure DrogeriaBtnClick(Sender: TObject);
    procedure KontrolaCennikuTimer(Sender: TObject);
    procedure KontrolaTovaruTimer(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure MasoBtnClick(Sender: TObject);
    procedure MrazeneBtnClick(Sender: TObject);
    procedure OdhlasitBtnClick(Sender: TObject);
    procedure LogInBtnClick(Sender: TObject);
    procedure PecivoBtnClick(Sender: TObject);
    procedure PrejstKPlatbeBtnClick(Sender: TObject);
    procedure OvocieBtnClick(Sender: TObject);
    procedure PrepisSkladTimer(Sender: TObject);
    procedure PrepisStatistikyTimer(Sender: TObject);
    procedure StornoBtnClick(Sender: TObject);
    procedure KontrolaSkladuTimer(Sender: TObject);
    procedure VsetokTovarBtnClick(Sender: TObject);
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
    procedure RozdelenieDoRecordov;

  private
    { private declarations }
  public
    { public declarations }
  end;

type zoznamTovaru=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznamPokladnikov=record
     meno: string;
     kod: string;
end;

type zoznamVsetkehoTovaru=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznamOvocia=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznamzeleniny=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznampeciva=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznammrazeneho=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznamdrogerie=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznammasa=record
     kod: string;
     nazov: string;
     predajnacena: float;
     pocet: integer;
end;

type zoznamUctenka=record
     kod: string;
     nazov: string;
     pocet: integer;
     cena: float;
end;

const n=6;
      m=150;
      o=10;
      p=50;

var
  pokladnici: array[1..n] of zoznampokladnikov;
  tovar: array[1..m] of zoznamtovaru;
  vsetoktovar: array[1..m] of zoznamvsetkehotovaru;
  sklad: array[1..2,1..m] of integer;
  ovocie: array[1..o] of zoznamovocia;
  zelenina: array[1..o] of zoznamzeleniny;
  pecivo: array[1..o] of zoznampeciva;
  mrazene: array[1..o] of zoznammrazeneho;
  drogeria: array[1..o] of zoznamdrogerie;
  maso: array[1..o] of zoznammasa;
  uctenka: array[1..p] of zoznamuctenka;
  //subory: array of textfile;
  i, itemindex, pocetobjektov, q, ov, z, pe, mr, d, ma, praca, vt, x: integer;
  celkom : float;
  subor1, tovarFile, cennikFile, skladFile, subor5, statistikyFile , skladLock: textfile;
  znak: char;
  kod, pokladnik, kodtovaru, kodpokladnika, filePath: string;
  zvolenyClick, skladPrepisany, statistikyPrepisane: boolean;
  Form1: TForm1;
  gen : int64;
  k, lines: integer;
  suborStatistiky: string;
  citamZnak : char;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Prihlasenie;     //procedura
var
  k: boolean;
begin
celkom:=0;
edit2.clear;
kodpokladnika:=edit1.text;
k:=false;
for i:=1 to n do
    begin
    if pokladnici[i].kod = kodpokladnika then
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

procedure TForm1.SchovajObjekty;  //tato procedura nebude potrebna ak bude viac formov
begin
image1.visible:=false;
label2.visible:=false;
label3.visible:=false;
label4.visible:=false;
label5.visible:=false;
Label6.visible:=false;
Label7.visible:=false;
OvocieBtn.visible:=false;
PecivoBtn.visible:=false;
DrogeriaBtn.visible:=false;
ZeleninaBtn.visible:=false;
MrazeneBtn.visible:=false;
MasoBtn.visible:=false;
VyhladajBtn.visible:=false;
VlozBtn.visible:=false;
PrejstKPlatbeBtn.visible:=false;
StornoBtn.visible:=false;
VsetokTovarBtn.Visible:=false;
//NakupBtn.visible:=false;
OdhlasitBtn.visible:=false;
ZaplatitBtn.visible:=false;
edit2.visible:=false;
edit3.visible:=false;
listbox1.Visible:=false;
listbox2.visible:=false;
memo1.Visible:=false;
memo2.visible:=false;
end;

procedure TForm1.Nakup; //procedura namiesto buttonu
begin
for i:=1 to pocetobjektov do
                             begin
                               uctenka[i].kod:=' ';
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
VsetokTovarBtn.visible:=true;
OvocieBtn.visible:=true;
PecivoBtn.visible:=true;
DrogeriaBtn.visible:=true;
ZeleninaBtn.visible:=true;
MrazeneBtn.visible:=true;
MasoBtn.visible:=true;
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
memo2.visible:=false;

statistikyPrepisane := false;
skladPrepisany := false;

end;

procedure TForm1.LogInBtnClick(Sender: TObject);
begin
Prihlasenie;
end;

procedure TForm1.PecivoBtnClick(Sender: TObject);
begin
Edit2.Clear;
label2.Visible:=false;
praca:=3;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to pe do
    ListBox1.Items.Add(pecivo[i].nazov+'       '+inttostr(pecivo[i].pocet)+' ks');
end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
begin
Prihlasenie;
end;

procedure TForm1.VyhladajBtnClick(Sender: TObject);
var
  mameTovar: boolean;
begin
memo2.clear;
mameTovar:= False;
Label2.Visible:= False;
ListBox1.Items.Clear;
kodTovaru:=Edit3.Text;
   for i:=1 to m do
      if (kodTovaru = tovar[ i ].kod) and not (kodTovaru = '')  then
         begin
           mameTovar:= true;
           if tovar[ i ].pocet > 0 then
             begin
               zvolenyClick:= true;
               praca:=7;
               Label2.Caption:= tovar[ i ].nazov;
               Memo2.visible:= true;
               Memo2.append(tovar[ i ].nazov);
               Label2.Visible:= True;
               itemIndex:= i; // len tak
             end
           else
             begin
               ShowMessage(tovar[i].nazov+': Prepáčte, ale tento tovar momentálne nemáme na sklade.');
               break;
             end;
         end;
   if mameTovar = false then
         ShowMessage('Tovar s takýmto kódom neexistuje');
edit3.clear;
end;

procedure TForm1.RozdelenieDoRecordov;
var i,j: integer;
begin
vt:=0;
ov:=0;
z:=0;
pe:=0;
mr:=0;
d:=0;
ma:=0;
//memo3.append(tovar[1].kod);

for i:=1 to x do
   if (tovar[i].pocet>0) and (tovar[i].predajnacena>0) then
     begin
       inc(vt);
       vsetoktovar[vt].kod:=tovar[i].kod;
       vsetoktovar[vt].nazov:=tovar[i].nazov;
       //mrazene[mr].nakupnacena:=tovar[i].nakupnacena;
       vsetoktovar[vt].predajnacena:=tovar[i].predajnacena;
       vsetoktovar[vt].pocet:=tovar[i].pocet;
     end;

for i:=1 to x do
    begin
         if (tovar[i].pocet>0) and (tovar[i].predajnacena>0) then
            begin
                if (tovar[i].kod[1]+tovar[i].kod[2]) = '11' then
                   begin
                     inc(ov);
                     ovocie[ov].kod:=tovar[i].kod;
                     ovocie[ov].nazov:=tovar[i].nazov;
                     //ovocie[ov].nakupnacena:=tovar[i].nakupnacena;
                     ovocie[ov].predajnacena:=tovar[i].predajnacena;
                     ovocie[ov].pocet:=tovar[i].pocet;
                     //memo3.append(ovocie[o].kod+ovocie[o].nazov+inttostr(ovocie[o].nakupnacena)+inttostr(ovocie[o].predajnacena)+inttostr(ovocie[o].pocet));
                   end;
                   if (tovar[i].kod[1]+tovar[i].kod[2]) = '12' then
                   begin
                     inc(z);
                     zelenina[z].kod:=tovar[i].kod;
                     zelenina[z].nazov:=tovar[i].nazov;
                     //zelenina[z].nakupnacena:=tovar[i].nakupnacena;
                     zelenina[z].predajnacena:=tovar[i].predajnacena;
                     zelenina[z].pocet:=tovar[i].pocet;
                     //memo3.append(zelenina[z].kod+zelenina[z].nazov+inttostr(zelenina[z].nakupnacena)+inttostr(zelenina[z].predajnacena)+inttostr(zelenina[z].pocet));
                   end;
                if (tovar[i].kod[1]+tovar[i].kod[2]) = '13' then
                   begin
                     inc(pe);
                     pecivo[pe].kod:=tovar[i].kod;
                     pecivo[pe].nazov:=tovar[i].nazov;
                     //pecivo[pe].nakupnacena:=tovar[i].nakupnacena;
                     pecivo[pe].predajnacena:=tovar[i].predajnacena;
                     pecivo[pe].pocet:=tovar[i].pocet;
                     //memo3.append(pecivo[p].kod+pecivo[p].nazov+inttostr(pecivo[p].nakupnacena)+inttostr(pecivo[p].predajnacena)+inttostr(pecivo[p].pocet));
                   end;
                if (tovar[i].kod[1]+tovar[i].kod[2]) = '14' then
                   begin
                     inc(mr);
                     mrazene[mr].kod:=tovar[i].kod;
                     mrazene[mr].nazov:=tovar[i].nazov;
                     //mrazene[mr].nakupnacena:=tovar[i].nakupnacena;
                     mrazene[mr].predajnacena:=tovar[i].predajnacena;
                     mrazene[mr].pocet:=tovar[i].pocet;
                     //memo3.append(mrazene[mr].kod+mrazene[mr].nazov+inttostr(mrazene[mr].nakupnacena)+inttostr(mrazene[mr].predajnacena)+inttostr(mrazene[mr].pocet));
                   end;
                if (tovar[i].kod[1]+tovar[i].kod[2]) = '15' then
                   begin
                     inc(d);
                     drogeria[d].kod:=tovar[i].kod;
                     drogeria[d].nazov:=tovar[i].nazov;
                     //drogeria[d].nakupnacena:=tovar[i].nakupnacena;
                     drogeria[d].predajnacena:=tovar[i].predajnacena;
                     drogeria[d].pocet:=tovar[i].pocet;
                     //memo3.append(drogeria[d].kod+drogeria[d].nazov+inttostr(drogeria[d].nakupnacena)+inttostr(drogeria[d].predajnacena)+inttostr(drogeria[d].pocet));
                   end;
                 if (tovar[i].kod[1]+tovar[i].kod[2]) = '16' then
                   begin
                     inc(ma);
                     maso[ma].kod:=tovar[i].kod;
                     maso[ma].nazov:=tovar[i].nazov;
                     //maso[ma].nakupnacena:=tovar[i].nakupnacena;
                     maso[ma].predajnacena:=tovar[i].predajnacena;
                     maso[ma].pocet:=tovar[i].pocet;
                     //memo3.append(maso[m].kod+maso[m].nazov+inttostr(maso[m].nakupnacena)+inttostr(maso[m].predajnacena)+inttostr(maso[m].pocet));
                   end;

            end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
cenaString: string;
hold,j,x2,x3,x4,pocet: integer; //x je premenna na pocet riadkov v txt subore
cena : float;
begin
//cesta k suboru
filePath :=''; // '\\comenius\public\market\tima\';
if (FileExists( filePath +  'SKLAD.txt' ) = true) and  (FileExists(  filePath + 'TOVAR.txt' ) = true)
   and (FileExists ( filePath +  'CENNIK.txt' ) = true) then
     begin
        if FileExists ( filePath +  'STATISTIKY.txt' ) = false then
             begin
               assignfile( statistikyFile, filePath +  'STATISTIKY.txt' );
               rewrite( statistikyFile );
               write( statistikyFile, '0');
               writeln( statistikyFile );
               closefile( statistikyFile );
             end;
        KontrolaTovaru.Enabled := true;
        KontrolaCenniku.Enabled := true;
        KontrolaSkladu.Enabled := true;




        statistikyPrepisane := false;
        skladPrepisany := false;

        Randomize;
        DefaultFormatSettings.DecimalSeparator := '.';
        q:=0; //premenna na poradove cislo uctenky
        celkom:=0;
        ListBox1.Items.Clear;
        ListBox2.Items.Clear;
        image1.picture.loadfromfile('logo.png');
        Label6.Caption:='Košík';
        SchovajObjekty;  //vsetky az na label1,edit1 a LogInBtn

        AssignFile( subor1 , filePath + 'pokladnici.txt' );
        Reset(subor1);
        i:=0;
        while not eof(subor1) do     //nacitanie mien a kodov pokladnikov
        begin
             inc(i);
             readln(subor1,pokladnici[i].meno);
             readln(subor1,pokladnici[i].kod);
             //memo3.append(pokladnici[i].meno+pokladnici[i].kod);
        end;
        closefile(subor1);

        assignfile(tovarFile,filePath + 'TOVAR.txt');
        reset(tovarFile);
        readln(tovarFile,x2);
        //memo3.append(inttostr(x2));
        for i:=1 to x2 do
            begin
               kod:='';
               read(tovarFile,znak);
               repeat
                     tovar[i].kod:=tovar[i].kod+znak;
                     read(tovarFile,znak);
               until znak=';';
            //memo3.append(tovar[i].kod);
            readln(tovarFile,tovar[i].nazov);  //precita cely string po koniec a skoci na dalsi riadok
            //memo3.append(tovar[i].nazov);
            end;
        closefile(tovarFile);

        assignfile(cennikFile,filePath + 'CENNIK.txt');
        reset(cennikFile);
        readln(cennikFile,x3);
        //memo3.Append(inttostr(x3));
        for i:=1 to x3 do
            begin
                 kod:='';
                 read(cennikFile,znak);
                 repeat
                       kod:=kod+znak;
                       read(cennikFile,znak);
                 until znak = ';';
                 repeat
                       read(cennikFile,znak);
                 until znak = ';';

                 ReadLn(cennikFile,cenaString);
                 {cenaString := '';
                 repeat
                       read(cennikFile,znak);
                       cenaString := cenaString + znak;
                 until Eoln(cennikFile);   }

            //memo3.append(kod);
            cena := StrToFloat(cenaString);
            for j:=1 to x3 do
                 if tovar[j].kod = kod then
                    begin
                         tovar[j].predajnacena := cena;
                         //memo3.append(inttostr(tovar[j].nakupnacena));
                         //memo3.append(inttostr(tovar[j].predajnacena));
                    end;
            end;
        closefile(cennikFile);

        assignfile(skladFile,filePath + 'SKLAD.txt');
        reset(skladFile);
        readln(skladFile,x4);
        for i:=1 to x4 do
            begin
               kod:='';
               read(skladFile,znak);
               repeat
                     kod:=kod+znak;
                     read(skladFile,znak);
               until znak=';';
               //memo2.append(kod);
               readln(skladFile,pocet);
               //memo2.append(inttostr(pocet));
            for j:=1 to x4 do
               if tovar[j].kod=kod then tovar[j].pocet:=pocet;
             //memo1.append(inttostr(tovar[i].kod)+tovar[i].nazov+inttostr(tovar[i].nakupnacena)+inttostr(tovar[i].predajnacena)+inttostr(tovar[i].pocet));
            end;
        closefile(skladFile);

        x:=x2;

        RozdelenieDoRecordov;
     end
     else
     Chyba1.Enabled:= True;

end;

procedure TForm1.PrejstKPlatbeBtnClick(Sender: TObject);
begin
SchovajObjekty;
memo1.clear;
label6.visible:=true;
memo1.visible:=true;
ZaplatitBtn.visible:=true;
memo1.append('Lazarmarket');
memo1.append(' ');
memo1.append(datetostr(date)+'  '+timetostr(time));
memo1.append(' ');
memo1.append('Obsluhuje Vas: '+pokladnik);
memo1.append(' ');
for i:=1 to pocetobjektov do
    (memo1.append(uctenka[i].kod+'  '+uctenka[i].nazov+'         '+floattostr(uctenka[i].pocet)+'x'+floattostr(uctenka[i].cena)+'€'+'    '+floattostr(uctenka[i].pocet*uctenka[i].cena)+'€'));
memo1.append(' ');
memo1.append('---------------------------');
memo1.append(floattostr(celkom)+' €');
end;

procedure TForm1.OvocieBtnClick(Sender: TObject);
begin
Edit2.Clear;
label2.Visible:=false;
praca:=1;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to ov do
    ListBox1.Items.Add(ovocie[i].nazov+'       '+inttostr(ovocie[i].pocet)+' ks');
end;



procedure TForm1.PrepisSkladTimer(Sender: TObject);
var
f: integer;
begin
if FileExists( filePath + 'SKLAD_LOCK.txt' ) = false then
   begin
        f := FileCreate( filePath + 'SKLAD_LOCK.txt' );
        FileClose( f );
        assignfile(skladFile,filePath + 'SKLAD.txt');
        rewrite(skladFile);
        writeln(skladFile,x);

        for i:=1 to x do
            writeln(skladFile,tovar[i].kod+';'+inttostr(tovar[i].pocet));

        closefile(skladFile);
        DeleteFile( filePath + 'SKLAD_LOCK.txt' );

        skladPrepisany := true;

        if (skladPrepisany = true) and (statistikyPrepisane = true) then
           Nakup;

        PrepisSklad.Enabled := False;
   end;
end;

procedure TForm1.PrepisStatistikyTimer(Sender: TObject);
var
f: integer;
begin
if FileExists( filePath + 'STATISTIKY_LOCK.txt' ) = false then
   begin
      f := FileCreate( filePath + 'STATISTIKY_LOCK.txt' );
     FileClose( f );

      suborStatistiky := '';
      Assignfile( statistikyFile , filePath + 'STATISTIKY.txt' );
      Reset( statistikyFile );
      Read( statistikyFile , lines );

      Repeat
            Read( statistikyFile , citamZnak );
            suborStatistiky := suborStatistiky + citamZnak;
      until Eof( statistikyFile );
      closefile( statistikyFile );

      Assignfile( statistikyFile , filePath + 'STATISTIKY.txt' );
      Rewrite( statistikyFile );
      Write( statistikyFile , inttostr(lines + pocetObjektov) + suborStatistiky );

      for k := 1 to pocetobjektov do
           writeln( statistikyFile,  'P;' + inttostr( gen ) + ';' + uctenka[k].kod + ';' + inttostr(uctenka[k].pocet) + ';' + floattostr(uctenka[k].cena));

       closefile( statistikyFile );

       DeleteFile( filePath + 'STATISTIKY_LOCK.txt' );

       statistikyPrepisane := true;

       if (skladPrepisany = true) and (statistikyPrepisane = true) then
       Nakup;

       PrepisStatistiky.Enabled := False;


   end;
end;

procedure TForm1.StornoBtnClick(Sender: TObject);
var
  stornoIndex, i: integer;
  zvolil_som : boolean;
begin
     case QuestionDlg ('STORNO','Chcete stornovať celý nákup alebo zvolenú položku?',mtCustom,[mrYes,'Nákup', mrNo , 'Položku', 'IsDefault'],'') of
        mrYes: if PasswordBox( 'STORNO' , 'Zadajte váš kód:' ) = kodpokladnika  then
           begin
             SchovajObjekty;
             //NakupBtn.visible:=true;
             listbox1.Items.clear;
             listbox2.items.clear;
             Nakup;
             for i:=1 to pocetobjektov do
                 begin
                   uctenka[i].kod:=' ';
                   uctenka[i].nazov:=' ';
                   uctenka[i].pocet:=0;
                   uctenka[i].cena:=0;
                 end;
           end
        else ShowMessage('Nesprávny kód.');
        mrNo:  begin
               zvolil_som := false;
                for i := 0 to (ListBox2.Count - 1) do
                    if ListBox2.Selected[ i ] = True then
                       zvolil_som := true;
                if zvolil_som = true then
                  if PasswordBox( 'STORNO' , 'Zadajte váš kód:' ) =  kodpokladnika  then
                    begin
                      for i := 0 to (ListBox2.Count - 1) do
                          if ListBox2.Selected[ i ] = True then
                             stornoIndex := i;

                      Listbox2.Items.Delete(stornoIndex);
                      stornoindex:=stornoindex+1;
                      celkom:=celkom-(uctenka[stornoindex].cena*uctenka[stornoindex].pocet);
                      label7.caption:='Celkom: '+floattostr(celkom)+'€';

                      if stornoindex=pocetobjektov then
                         begin
                      uctenka[stornoindex].kod:=' ';
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
                 else ShowMessage( 'Nesprávny kód.' )
               else ShowMessage( 'Prosím, zvoľte položku na stornovanie.' );
        end;
        mrCancel: ;
     end;

end;

procedure TForm1.KontrolaSkladuTimer(Sender: TObject);
var
   x4,pocet,j,f: integer; //x je premenna na pocet riadkov v txt subore

begin

if  FileExists( filePath + 'SKLAD_LOCK.txt' ) = false then
   begin
   f := FileCreate( filePath + 'SKLAD_LOCK.txt' );
   FileClose( f );
    reset( skladFile );
    readln( skladFile , x4 );
    for i := 1 to x4 do
        begin
           kod := '';
           read( skladFile , znak );
           repeat
                 kod := kod + znak;
                 read( skladFile , znak );
           until znak = ';';

           ReadLn( skladFile , pocet );

        for j:=1 to x4 do
           if tovar[ j ].kod = kod then
              tovar[ j ].pocet := pocet;
         //memo1.append(inttostr(tovar[i].kod)+tovar[i].nazov+inttostr(tovar[i].nakupnacena)+inttostr(tovar[i].predajnacena)+inttostr(tovar[i].pocet));
        end;
      closefile( skladFile );

      x:=x4;

     RozdelenieDoRecordov;
    DeleteFile( filePath + 'SKLAD_LOCK.Txt' );
   end;
end;

procedure TForm1.VsetokTovarBtnClick(Sender: TObject);
begin
praca:=0;
Edit2.Clear;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to vt do
    ListBox1.Items.Add(vsetoktovar[i].nazov+'       '+inttostr(vsetoktovar[i].pocet)+' ks');
end;

procedure TForm1.ZaplatitBtnClick(Sender: TObject);
var i,j : integer;
begin
SchovajObjekty;
//NakupBtn.visible:=true;
gen := random(99999999 - 10000000) + 10000000;
assignfile(subor5,filePath+'uctenky\' + 'P'+inttostr(gen)+'.txt');
rewrite(subor5);
writeln(subor5,'                                                                           Lazarmarket');
writeln(subor5,datetostr(date)+'  '+timetostr(time));
writeln(subor5,'Obsluhuje Vas: '+pokladnik);
writeln(subor5);
for i:=1 to pocetobjektov do
    (writeln(subor5,uctenka[i].kod+'  '+uctenka[i].nazov+'         '+inttostr(uctenka[i].pocet)+'x'+floattostr(uctenka[i].cena)+'€'+'    '+floattostr(uctenka[i].pocet*uctenka[i].cena)+'€'));
writeln(subor5);
writeln(subor5,'---------------------------');
writeln(subor5,floattostr(celkom)+' €');
closefile(subor5);

for i:=1 to pocetobjektov do
    for j:=1 to x do
        begin
           if uctenka[i].kod=tovar[j].kod then
              begin
                //memo3.append(inttostr(tovar[j].pocet));
                tovar[j].pocet:=tovar[j].pocet-uctenka[i].pocet;
                //memo3.append(inttostr(tovar[j].pocet));
                break;
              end;
        end;

//prepisujem sklad
  PrepisSklad.Enabled := True;

 //prepisujem statistiky
 //niekde v timeri
 PrepisStatistiky.Enabled := True;
end;

procedure TForm1.ZeleninaBtnClick(Sender: TObject);
begin
Edit2.Clear;
label2.Visible:=false;
praca:=2;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to z do
    ListBox1.Items.Add(zelenina[i].nazov+'       '+inttostr(zelenina[i].pocet)+' ks');
end;

procedure TForm1.VlozBtnClick(Sender: TObject);  //dve moznosti: vloz ak je to list objektov alebo je vyhladany podla kodu
var
pocet: integer;
begin
if zvolenyClick = true then
   begin
     trystrtoint( edit2.text , pocet );
     if pocet > 0 then
        begin
             //itemindex:= itemindex+1;
             inc( pocetobjektov );
        //memo2.append('pocet objektov '+inttostr(pocetobjektov));
             case praca of
                  0: begin
                          Listbox2.Items.Add( vsetoktovar[ itemindex ].kod + '  ' + vsetoktovar[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + Floattostr( vsetoktovar[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*vsetoktovar[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= vsetoktovar[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= vsetoktovar[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= vsetoktovar[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  1: begin
                          Listbox2.Items.Add( ovocie[ itemindex ].kod + '  ' + ovocie[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + Floattostr( ovocie[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*ovocie[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= ovocie[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= ovocie[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= ovocie[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  2: begin
                          Listbox2.Items.Add( zelenina[ itemindex ].kod + '  ' + zelenina[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + floattostr( zelenina[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*zelenina[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= zelenina[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= zelenina[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= zelenina[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  3: begin
                          Listbox2.Items.Add( pecivo[ itemindex ].kod + '  ' + pecivo[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + floattostr( pecivo[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*pecivo[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= pecivo[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= pecivo[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= pecivo[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  4: begin
                          Listbox2.Items.Add( mrazene[ itemindex ].kod + '  ' + mrazene[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + floattostr( mrazene[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*mrazene[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= mrazene[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= mrazene[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= mrazene[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  5: begin
                          Listbox2.Items.Add( drogeria[ itemindex ].kod + '  ' + drogeria[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + floattostr( drogeria[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*drogeria[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= drogeria[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= drogeria[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= drogeria[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  6: begin
                          Listbox2.Items.Add( maso[ itemindex ].kod + '  ' + maso[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + floattostr( maso[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*maso[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= maso[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= maso[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= maso[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
                  7: begin      //prosim, ako je mozne, ze to funguje s poziciou na zaklade premennej itemindex? na zaklade toho, co si, Samko, napisal do procedury VyhladajBtn OnClick.
                          Listbox2.Items.Add( tovar[ itemindex ].kod + '  ' + tovar[ itemindex ].nazov + '         '+ inttostr( pocet ) + 'x' + floattostr( tovar[ itemindex ].predajnacena ) + '€' + '    ' + floattostr( pocet*tovar[ itemindex ].predajnacena ) + '€' );
                          uctenka[ pocetobjektov ].kod:= tovar[ itemindex ].kod;
                          uctenka[ pocetobjektov ].nazov:= tovar[ itemindex ].nazov;
                          uctenka[ pocetobjektov ].cena:= tovar[ itemindex ].predajnacena;
                          uctenka[ pocetobjektov ].pocet:= pocet;
                     end;
             end;

        //memo2.append(inttostr(uctenka[pocetobjektov].kod)+'  '+uctenka[pocetobjektov].nazov+'         '+inttostr(uctenka[pocetobjektov].pocet)+'x'+inttostr(uctenka[pocetobjektov].cena)+'€'+'    '+inttostr(uctenka[pocetobjektov].pocet*uctenka[pocetobjektov].cena)+'€');
             celkom:= celkom + ( uctenka[ pocetobjektov ].pocet*uctenka[ pocetobjektov ].cena );
             edit2.clear;
             label7.caption:='Celkom: '+floattostr(celkom)+'€';
             label7.visible:=true;
             Label2.caption:='';
             memo2.clear;
             zvolenyClick:= false;
        end else
             ShowMessage('Nie je možné zadať nulový počet. Opravte sa, prosím');
   end;

end;

procedure TForm1.ListBox1Click(Sender: TObject);
var i: integer;
begin
label2.visible:=false;
zvolenyClick := false;
if  ListBox1.Count > 0 then
   begin
      for i:= 0 to ListBox1.Count-1 do
          if ListBox1.Selected[ i ] = True then
             begin
                  itemIndex:= i+1;
                  zvolenyClick := true;
                  Label2.Visible:= True;
                  Break;
             end;

      case praca of
         0: Label2.Caption:= (vsetoktovar[itemIndex].nazov);
         1: Label2.Caption:= (ovocie[itemIndex].nazov);
         2: Label2.Caption:= (zelenina[itemIndex].nazov);
         3: Label2.Caption:= (pecivo[itemIndex].nazov);
         4: Label2.Caption:= (mrazene[itemIndex].nazov);
         5: Label2.Caption:= (drogeria[itemIndex].nazov);
         6: Label2.Caption:= (maso[itemIndex].nazov);
      end;
   end;
end;

procedure TForm1.OdhlasitBtnClick(Sender: TObject);
begin
     SchovajObjekty;
     Label1.Visible:= True;
     Edit1.Visible:= True;
     Loginbtn.Visible:= True;
     Edit1.Caption:= '';
end;

procedure TForm1.MrazeneBtnClick(Sender: TObject);
begin
Edit2.Clear;
label2.Visible:=false;
praca:=4;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to mr do
    ListBox1.Items.Add(mrazene[i].nazov+'       '+inttostr(mrazene[i].pocet)+' ks');
end;

procedure TForm1.DrogeriaBtnClick(Sender: TObject);
begin
Edit2.Clear;
label2.Visible:=false;
praca:=5;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to d do
    ListBox1.Items.Add(drogeria[i].nazov+'       '+inttostr(drogeria[i].pocet)+' ks');
end;


procedure TForm1.Chyba1Timer(Sender: TObject);
begin
Chyba1.Enabled:= false;
Edit1.Visible:=false;
LogInBtn.visible:=false;
Label1.visible:=false;
SchovajObjekty;
//Edit1.Visible:=false;
ShowMessage('Chýba časť databázy. Napravte chybu a znovu zapnite program.');
Close;
end;

procedure TForm1.MasoBtnClick(Sender: TObject);
begin
Edit2.Clear;
label2.Visible:=false;
praca:=6;
Memo2.visible:=false;
ListBox1.Items.Clear;
for i:=1 to ma do
    ListBox1.Items.Add(maso[i].nazov+'       '+inttostr(maso[i].pocet)+' ks');
end;

procedure TForm1.KontrolaCennikuTimer(Sender: TObject);
var cenastring: string;
    x3, j ,f : integer;
    cena: float;
begin
if FileExists( filePath + 'CENNIK_LOCK.txt' ) = false then
   begin
     f := FileCreate( filePath + 'CENNIK_LOCK.txt' );
     FileClose( f );

      reset(cennikFile);
      readln(cennikFile,x3);
      for i:=1 to x3 do
          begin
               kod:='';
               read(cennikFile,znak);
               repeat
                     kod:=kod+znak;
                     read(cennikFile,znak);
               until znak = ';';
               repeat
                     read(cennikFile,znak);
               until znak = ';';

               ReadLn(cennikFile,cenaString);//

          cena := StrToFloat(cenaString);
          for j:=1 to x3 do
               if tovar[j].kod = kod then
                  begin
                       tovar[j].predajnacena := cena;
                       //memo3.append(inttostr(tovar[j].nakupnacena));
                       //memo3.append(inttostr(tovar[j].predajnacena));
                  end;
          end;
      closefile(cennikFile);

      DeleteFile( filePath + 'CENNIK_LOCK.txt' );
   end;
end;

procedure TForm1.KontrolaTovaruTimer(Sender: TObject);
var
   x2,pocet,j,f: integer; //x je premenna na pocet riadkov v txt subore

begin
if  FileExists( filePath + 'TOVAR_LOCK.txt' ) = false then
   begin
   f := FileCreate( filePath + 'TOVAR_LOCK.txt' );
   FileClose( f );
    reset( tovarFile );
    readln( tovarFile , x2 );
    for i := 1 to x2 do
        begin
           kod := '';
           tovar[i].kod := '';
           read( tovarFile , znak );
           repeat
                 tovar[i].kod:=tovar[i].kod+znak;
                 read( tovarFile , znak );
           until znak = ';';
           Readln(tovarFile,tovar[i].nazov);
        end;
    closefile( tovarFile );

    x:=x2;   //nepamatam si, na co je to tu.
             //asi aby sme si prepisali globalnu premennu, ktora nam hovori o pocte vsetkeho tovaru

    RozdelenieDoRecordov;

    DeleteFile( filePath + 'TOVAR_LOCK.Txt' );
   end;

end;

procedure TForm1.Label2Click(Sender: TObject);
begin

end;


end.

