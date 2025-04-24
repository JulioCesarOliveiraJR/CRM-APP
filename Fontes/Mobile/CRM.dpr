program CRM;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  Frame.Negocio in 'Frames\Frame.Negocio.pas' {FrameNegocio: TFrame},
  uLoading in 'Units\uLoading.pas',
  DataModule.Global in 'DataModules\DataModule.Global.pas' {DmGlobal: TDataModule},
  uSession in 'Units\uSession.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.Run;
end.
