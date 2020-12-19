with Ada.Text_IO,
     Ada.Command_Line;

procedure eighth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    Total_Instructions : constant Natural := 654;
    --Total_Instructions : constant Natural := 9;

    type Opcode is (acc, jmp, nop);

    type Instruction is
        record
            op : Opcode;
            param : Integer;
            last_visit : Natural;
        end record;

    function Parse_Instruction(raw : String) return Instruction is
        op : Opcode := Acc;
        param : Integer := 0;
    begin
        op := Opcode'Value(raw(raw'First..raw'First + 2));
        param := Integer'Value(raw(raw'First + 4..raw'Last));
        --Text_IO.Put_Line("Op: " & Opcode'Image(op) &
        --    ", Param: " & Integer'Image(param));
        return (op => op, param => param, last_visit => 0);
    end Parse_Instruction;

    subtype IP_Range is Natural range 1..Total_Instructions;
    type Instruction_Memory is array(IP_Range) of Instruction;

    imem : Instruction_Memory;

    I : Natural := 1;

    -- Execute a single instruction and update CPU state
    procedure Execute_Instruction(isn : in out Instruction;
                                  accu : in out Integer;
                                  ip : in out Positive;
                                  visit_id : in Natural;
                                  revisited : out Boolean) is
    begin
        revisited := false;
        if isn.last_visit = visit_id then
            --Text_IO.Put_Line("Revisiting at IP " & Positive'Image(ip) & " ACC: " & Integer'Image(accu));
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
        isn.last_visit := visit_id;
    end Execute_Instruction;

    ip : Natural;
    accum : Integer;
    revisited : Boolean;
    candidate_found : Boolean := false;
    candidate : Natural := 1;
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

    for J in imem'Range loop
        if imem(J).op /= acc then
            case imem(J).op is
                when acc =>
                    Text_IO.Put_Line("Fatal: candidate was an acc???.");
                    return;
                when jmp =>
                    --Text_IO.Put_Line("Swapping a JMP for a NOP at " & Natural'Image(candidate));
                    imem(J).op := nop;
                when nop =>
                    --Text_IO.Put_Line("Swapping a NOP for a JMP at " & Natural'Image(candidate));
                    imem(J).op := jmp;
            end case;

            -- Execute the program
            ip := 1; -- Start at the top
            accum := 0;

            loop
                Execute_Instruction(imem(ip), accum, ip, J, revisited);
                if revisited then
                    -- Not a candidate
                    exit;
                end if;

                -- IP points outside this chunk of code, so success?
                if ip > Total_Instructions then
                    Text_IO.Put_Line("Found candidate at address " &
                        Natural'Image(J) &
                        " PC is at " & Natural'Image(ip) &
                        " Acc: " & Integer'Image(accum));
                    candidate_found := true;
                    candidate := J;
                    exit;
                end if;
            end loop;

            case imem(J).op is
                when acc =>
                    Text_IO.Put_Line("Fatal: candidate was an acc???.");
                    return;
                when jmp =>
                    -- Text_IO.Put_Line("Swapping a JMP for a NOP at " & Natural'Image(candidate));
                    imem(J).op := nop;
                when nop =>
                    --Text_IO.Put_Line("Swapping a NOP for a JMP at " & Natural'Image(candidate));
                    imem(J).op := jmp;
            end case;
        end if;

        if candidate_found then
            exit;
        end if;

    end loop;

    if not candidate_found then
        Text_IO.Put_Line("Did not find a candidate; aborting.");
        return;
    end if;

end eighth;

