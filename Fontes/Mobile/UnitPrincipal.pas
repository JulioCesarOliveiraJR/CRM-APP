unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.TabControl,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, uLoading, uSession;

type
  TFrmPrincipal = class(TForm)
    rectAbas: TRectangle;
    lytAba1: TLayout;
    Label1: TLabel;
    Image1: TImage;
    lytAba2: TLayout;
    Label2: TLabel;
    Image2: TImage;
    lytAba3: TLayout;
    Label3: TLabel;
    Image3: TImage;
    lytAba4: TLayout;
    Label4: TLabel;
    Image4: TImage;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    rectToolbar1: TRectangle;
    Label5: TLabel;
    imgRefreshDashboard: TImage;
    btnRefreshDashboard: TSpeedButton;
    rectToolbar2: TRectangle;
    Label6: TLabel;
    Image5: TImage;
    btnAddNegocio: TSpeedButton;
    rectToolbar3: TRectangle;
    Label7: TLabel;
    Rectangle1: TRectangle;
    Label8: TLabel;
    rectFundoAba1: TRectangle;
    Rectangle2: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    Image6: TImage;
    Label9: TLabel;
    lblDash1Valor: TLabel;
    lblDash1Qtd: TLabel;
    Rectangle3: TRectangle;
    Layout3: TLayout;
    Image7: TImage;
    Label12: TLabel;
    Layout4: TLayout;
    lblDash2Qtd: TLabel;
    lblDash2Valor: TLabel;
    Rectangle4: TRectangle;
    lytGrafico: TLayout;
    Label15: TLabel;
    lbNegocios: TListBox;
    lvNegocios: TListView;
    imgContato: TImage;
    procedure lytAba1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbNegociosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure MudarAba(lyt: TLayout);
    procedure ListarNegociosResumo;
    procedure NegociosResumoTerminate(Sender: TObject);
    procedure AddEtapaNegocio(etapa: string; qtd: integer; valor: double);
    procedure AddNegocioListview(id_negocio: integer; descricao,
      empresa: string; valor: double);
    procedure ListarNegocios(etapa: string);
    procedure NegociosTerminate(Sender: TObject);
  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.Global, Frame.Negocio;

procedure TFrmPrincipal.NegociosResumoTerminate(Sender: TObject);
begin
    lbNegocios.EndUpdate;
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;

    ListarNegocios(lbNegocios.ItemByIndex(0).tagstring);
end;

procedure TFrmPrincipal.NegociosTerminate(Sender: TObject);
begin
    lvNegocios.EndUpdate;
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    // Obtido na tela de login...
    TSession.ID_USUARIO := 1;
    //---------------------------
end;

procedure TFrmPrincipal.ListarNegocios(etapa: string);
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    lvNegocios.BeginUpdate;
    lvNegocios.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    begin
        // Acessar o servidor...
        DmGlobal.ListarNegocios(etapa, TSession.ID_USUARIO);

        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            while NOT DmGlobal.TabNegocios.eof do
            begin
                AddNegocioListview(DmGlobal.TabNegocios.fieldbyname('id_negocio').AsInteger,
                                   DmGlobal.TabNegocios.fieldbyname('descricao').asstring,
                                   DmGlobal.TabNegocios.fieldbyname('empresa').asstring,
                                   DmGlobal.TabNegocios.fieldbyname('valor').asfloat);

                DmGlobal.TabNegocios.Next;
            end;
        end);
    end);

    t.OnTerminate := NegociosTerminate;
    t.Start;
end;

procedure TFrmPrincipal.lbNegociosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    ListarNegocios(Item.TagString);
end;

procedure TFrmPrincipal.AddNegocioListview(id_negocio: integer;
                                           descricao, empresa: string;
                                           valor: double);
var
    item: TListViewItem;
begin
    item := lvNegocios.Items.Add;
    item.Height := 55;
    item.TagString := id_negocio.tostring;

    TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
    TListItemText(item.Objects.FindDrawable('txtEmpresa')).Text := empresa;
    TListItemText(item.Objects.FindDrawable('txtValor')).Text := FormatFloat('R$#,##0.00', valor);
    TListItemImage(item.Objects.FindDrawable('imgEmpresa')).Bitmap := imgContato.Bitmap;
end;


procedure TFrmPrincipal.AddEtapaNegocio(etapa: string;
                                        qtd: integer;
                                        valor: double);
var
    f: TFrameNegocio;
    item: TListBoxItem;
begin
    item := TListBoxItem.Create(lbNegocios);
    item.Width := 150;
    item.TagString := etapa;

    f := TFrameNegocio.Create(item);
    f.lblEtapa.Text := etapa;
    f.lblQtd.Text := FormatFloat('#,## negócios', qtd);
    f.lblValor.Text := FormatFloat('R$#,##0.00', valor);

    item.AddObject(f);

    lbNegocios.AddObject(item);
end;

procedure TFrmPrincipal.ListarNegociosResumo;
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');
    lbNegocios.BeginUpdate;
    lbNegocios.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    begin
        // Acessar o server p/ listar os resumos...
        DmGlobal.ListarNegociosResumo(TSession.ID_USUARIO);

        // Popular nossa lista...
        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            while NOT DmGlobal.TabNegociosResumo.eof do
            begin
                AddEtapaNegocio(DmGlobal.TabNegociosResumo.fieldbyname('etapa').asstring,
                                DmGlobal.TabNegociosResumo.fieldbyname('qtd').asinteger,
                                DmGlobal.TabNegociosResumo.fieldbyname('valor').asfloat);

                DmGlobal.TabNegociosResumo.Next;
            end;

            // Seleciona primeiro item...
            lbNegocios.ItemIndex := 0;
        end);


        //sleep(2000);
    end);

    t.OnTerminate := NegociosResumoTerminate;
    t.Start;
end;

procedure TFrmPrincipal.MudarAba(lyt: TLayout);
begin
    lytAba1.Opacity := 0.5;
    lytAba2.Opacity := 0.5;
    lytAba3.Opacity := 0.5;
    lytAba4.Opacity := 0.5;

    lyt.Opacity := 1;

    TabControl.GotoVisibleTab(lyt.Tag);

    if lyt.Tag = 1 then // Aba Negocios
        ListarNegociosResumo;
end;

procedure TFrmPrincipal.lytAba1Click(Sender: TObject);
begin
    MudarAba(TLayout(Sender));
end;

end.
