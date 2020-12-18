with Ada.Text_IO,
     Ada.Strings.Unbounded,
     Ada.Command_Line,
     Ada.Characters.Handling;

procedure second is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;
    package US renames Ada.Strings.Unbounded;

    function Handle_Line(line : String) return Boolean is
        package ACH renames Ada.Characters.Handling;

        function Parse_Num(str : in String;
                           offset : out Integer) return Integer is
            acc : Integer := 0;
        begin
            offset := 0;
            for I in str'Range loop
                offset := offset + 1;
                if ACH.Is_Digit(str(I)) then
                    acc := acc * 10;
                    acc := acc + Character'Pos(str(I)) - Character'Pos('0');
                else
                    return acc;
                end if;
            end loop;
            return 0;
        end Parse_Num;

        min : Integer := 0;
        max : Integer := 0;
        count : Integer := 0;
        offset : Integer := 0;
        str_offs : Integer := 0;
        needle : Character;
        needle_count : Integer := 0;
    begin
        min := Parse_Num(line, offset);
        str_offs := offset + 1;
        max := Parse_Num(line(str_offs..str_offs + 2), offset);
        str_offs := str_offs + offset;

        needle := line(str_offs);

        str_offs := str_offs + 3;

        for C in str_offs..line'Last loop
            if line(C) = needle then
                needle_count := needle_count + 1;
            end if;
        end loop;

        -- Ada.Text_IO.Put_Line("  Min: " & Integer'Image(min) & " Max: " & Integer'Image(max) & " Needle: " & needle & " Count: " & Integer'Image(needle_count) & " remaining: " & line(str_offs..line'Last));

        return needle_count <= max and needle_count >= min;
    end Handle_Line;


    file : Text_IO.File_Type;

    num_valid : Integer := 0;
    raw_line : Ada.Strings.Unbounded.Unbounded_String;
begin

    Text_IO.Put_Line("Advent of Code: 2.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of passwords and policies. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        --raw_line := US.To_Unbounded_String(Text_IO.Get_Line(file));
        --Text_IO.Put_Line("Read: " & US.To_String(raw_line));
        if Handle_Line(Text_IO.Get_Line(file)) then
            num_valid := num_valid + 1;
        end if;
    end loop;

    Text_IO.Put_Line("Count: " & Integer'Image(num_valid));

end second;

