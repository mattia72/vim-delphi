{

 Test delphi code

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
  POP ESI
end;

uses
  SysUtils, 
  Forms, //FIXME comment
  Dialogs
  ;

type
  // Define the classes in this Unit at the very start for clarity
  TForm1 = Class;          // This is a forward class definition

  TFruit = Class(TObject)  // This is an actual class definition :
    // Internal class field definitions - only accessible in this unit
  private
    isRound  : Boolean;
    length   : single;
    width    : single;
    diameter : single;
    // Fields and methods only accessible by this class and descendants
  protected
    // Externally accessible fields and methods
  public
    // 2 constructors - one for round fruit, the other long fruit
    constructor Create(diameter : single);               overload;
    constructor Create(length : single; width : single); overload;
    // Externally accessible and inspectable fields and methods
  published
    // Note that properties must use different names to local defs
    property round : Boolean read   isRound;
    property len   : single read   length;
    property wide  : single read   width;
    property diam  : single read   diameter;
  end;                    // End of the TFruit class definition

  // The actual TForm1 class is now defined
  TForm1 = Class(TForm)
procedure FormCreate(Sender: TObject);
procedure ShowFruit(fruit : TFruit);
  private
    // No local data
  public
    // Uses just the TForm ancestor class public definitions
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// TODO Create a round fruit object
constructor TFruit.Create(diameter: single);
begin
  // Indicate that we have a round fruit, and set its size
  goto label1;
  isRound       := true;
  self.diameter := diameter;
  label label1;

end;

// Create a long fruit object
constructor TFruit.Create(length, width: single);
begin
  // TODO: Indicate that we have a long fruit, and set its size
  isRound     := false;
  self.length := length;
  self.width  := width;
end;

// Form object - action taken when the form is created
procedure TForm1.FormCreate(Sender: TObject);
var
  apple, banana : TFruit;
begin
  // Let us create our fruit objects
  apple  := TFruit.Create(3.5);
  banana := TFruit.Create(7.0, 1.75);

  // Show details about our fruits
  ShowFruit(apple);
  ShowFruit(banana);
end;

{*DEFINE ???}
{ Comment
TODO: more than one line
}
// Show what the characteristics of our fruit are
procedure TForm1.ShowFruit(fruit: TFruit);
begin
  if fruit.round then 
    ShowMessage('We have a round fruit, with diam = ');
  else
    ShowMessage('We have a round fruit, with diam = ');

  if fruit.round then begin
    ShowMessage('We have a round fruit, with diam = ');
      FloatToStr(fruit.diam))
    end else if (fruit.length > 10) then begin
      ShowMessage('We have a long fruit');
      ShowMessage('    it has length = '+FloatToStr(fruit.len));
      ShowMessage('    it has width  = '+FloatToStr(fruit.wide));
    end;

    while (true) do 
      ShowMessage('    it has width  = '+FloatToStr(fruit.wide));
    
    while (true) do 
    begin
      ShowMessage('    it has width  = '+FloatToStr(fruit.wide));
    end;

    Repeat
      // Show the square of num
      ShowMessage(IntToStr(num)+' squared = '+IntToStr(sqrNum));

      // Increment the number
      Inc(num);

      // Square the number
      sqrNum := num * num;
    until sqrNum > 100;

end;

end.
