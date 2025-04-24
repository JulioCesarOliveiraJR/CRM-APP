unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, DataSet.Serialize, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDmGlobal = class(TDataModule)
    TabNegociosResumo: TFDMemTable;
    TabNegocios: TFDMemTable;
  private

  public
    procedure ListarNegociosResumo(id_usuario: integer);
    procedure ListarNegocios(etapa: string; id_usuario: integer);
  end;

var
  DmGlobal: TDmGlobal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.ListarNegociosResumo(id_usuario: integer);
var
    json_str: string;
begin
    TabNegociosResumo.FieldDefs.Clear;

    // Get no server...

    json_str := '[{"etapa": "Prospecção", "qtd": 6, "valor": 37760, "ordem": 1 },';
    json_str := json_str + '{"etapa": "Reunião", "qtd": 3, "valor": 11500, "ordem": 2},';
    json_str := json_str + '{"etapa": "Proposta", "qtd": 4, "valor": 7400, "ordem": 3}]';

    TabNegociosResumo.LoadFromJSON(json_str);
end;

procedure TDmGlobal.ListarNegocios(etapa: string; id_usuario: integer);
var
    json_str: string;
begin
    TabNegocios.FieldDefs.Clear;

    json_str := '[{"id_negocio": 1, "id_usuario": 1, "etapa": "Prospecção", "empresa": "Julio C O Jr.", "contato": "Julio Cesar de Oliveira", "fone": "(14) 997306149", "email": "jcjunior92.jj@gmail.com", "valor": 2500, ';
    json_str := json_str + '"dt_cadastro": "2025-04-23T00:00:00.000Z", "descricao": "Venda de Software"}, ';
    json_str := json_str + '{"id_negocio": 2, "id_usuario": 1, "etapa": "Prospecção", "empresa": "IMicrosystem", "contato": "Marcelo", "fone": "(14) 9999-9999", "email": "webmix@webmix.net.br", "valor": 15240, ';
    json_str := json_str + '"dt_cadastro": "2025-04-22T00:00:00.000Z", "descricao": "Venda de Software"}]';

    TabNegocios.LoadFromJSON(json_str);
end;

end.
