with Ada.Text_IO,
     Ada.Command_Line;

procedure eighth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    Total_Instructions : constant Natural := 654;
    -- Total_Instructions : constant Natural := 9;

    type Opcode is (acc, jmp, nop);

    type Instruction is
        record
            op : Opcode;
            param : Integer;
            visited : Boolean;
        end record;

    function Parse_Instruction(raw : String) return Instruction is
        op : Opcode := Acc;
        param : Integer := 0;
    begin
        op := Opcode'Value(raw(raw'First..raw'First + 2));
        param := Integer'Value(raw(raw'First + 4..raw'Last));
        Text_IO.Put_Line("Op: " & Opcode'Image(op) &
            ", Param: " & Integer'Image(param));
        return (op => op, param => param, visited => false);
    end Parse_Instruction;

    subtype IP_Range is Natural range 1..Total_Instructions;
    type Instruction_Memory is array(IP_Range) of Instruction;

    imem : Instruction_Memory;

    I : Natural := 1;

    accu : Integer := 0;
    ip : Positive := 1;

    -- Execute a single instruction and update CPU state
    procedure Execute_Instruction(isn : in out Instruction;
                                  accu : in out Integer;
                                  ip : in out Positive;
                                  revisited : out Boolean) is
    begin
        revisited := false;
        if isn.visited then
            Text_IO.Put_Line("Revisiting at IP " & Positive'Image(ip) & " ACC: " & Integer'Image(accu));
            revisited := true;
        end if;

        case isn.op is
            when acc =>
                accu := accu + isn.param;
                ip := ip + 1;
            when jmp =>
                ip := ip + isn.param;
            when nop =>
                ip := ip + 1;
        end case;
        isn.visited := true;
    end Execute_Instruction;

    revisited : Boolean := false;
begin

    Text_IO.Put_Line("Advent of Code: 8.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of instructions. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        imem(I) := Parse_Instruction(Text_IO.Get_Line(file));
        I := I + 1;
    end loop;

    loop
        Execute_Instruction(imem(ip), accu, ip, revisited);
        if revisited then
            exit;
        end if;
    end loop;

end eighth;

