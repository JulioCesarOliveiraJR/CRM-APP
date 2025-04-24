unit Frame.Negocio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameNegocio = class(TFrame)
    lblEtapa: TLabel;
    lblQtd: TLabel;
    lblValor: TLabel;
    Rectangle1: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
