{

 Test code for syntax highlight check 

 @project: vim-delphi
 @date   : 25.03.2019
 @author : mattia
}

unit Unit1;

interface

asm
  PUSH    ESI
  MOV     EAX, e
  MOV     ESI, DMTINDEX TExample.DynamicMethod
  CALL    System.@CallDynaInst
  POP     ESI
end;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Generics.Collections, StdCtrls;

type

	const
		CRLF                     = #13#10;             // special char
		UPPERCASE_HEX_CONSTANT   = $1af12;             //hex
		UPPERCASE_FLOAT_CONSTANT = 18.5  ;             //float
		UPPERCASE_FLOAT_CONSTANT2= 3.14e-12;           //float
		UPPERCASE_STR_CONSTANT   = 'This is a string'; //string

		CHILD_AGE_MAX = 18;

	TPerson = class
	private

		// NOTE: Field names begins with F and an UPPERCASE letter
		FFirstname: string; 
		FLastname: string;
		FAge: Integer;
	public
		function ToString: string; override;
		property FirstName: string read FFirstname write FFirstname;
		property LastName: string read FLastname write FLastname;
		property Age: Integer read FAge write FAge;

		// NOTE: Function parameters begins with underscore character 
		constructor Create(const _sFirstName, _sLastName : string; _iAge : Integer); virtual;

	end;

	TForm1 = class(TForm)
		Button1: TButton;
		ListBox1: TListBox;

		// NOTE: Common function parameters are recognized
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure Button1Click(Sender: TObject);
	private
		{ Private declarations }
		// FIXME : template parameters should get delphiTemplateParameter 
		FPersonList : TObjectList<TPerson>;
	public
		{ Public declarations }
	end;

var
	Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
	Person: TPerson;
begin
	ListBox1.Clear;

	for Person in FPersonList do
		ListBox1.Items.Add(Person.ToString() + UPPERCASE_STR_CONSTANT);
end;

// NOTE: Common function parameters are recognized
procedure TForm1.FormCreate(Sender: TObject);
begin
	FPersonList := TObjectList<TPerson>.Create(True);

	FPersonList.Add(TPerson.Create('Fred', 'Flintstone', 40));
	FPersonList.Add(TPerson.Create('Wilma', 'Flintstone', 38));
	FPersonList.Add(TPerson.Create('Pebbles', 'Flintstone', 1));
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
	FPersonList.Free;
end;

{ TPerson }

// NOTE: Common function parameters are recognized
constructor TPerson.Create(const _sFirstName, _sLastName : string; _iAge : Integer);
begin
	self.LastName := _sLastName;
	self.FirstName := _sFirstName;
	self.Age := _iAge;
end;

function TPerson.ToString: string;
begin
	Result := Format('%s %s : Age %d', [FirstName, LastName, Age]);
	if Age < CHILD_AGE_MAX then begin
		Result := Result + ' is a child';
	end;
end;

end.
