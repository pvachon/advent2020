with Ada.Text_IO,
     Ada.Command_Line;

procedure Sixth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    subtype Questions_Range is Natural range 1..26;
    type Question_Mask is array(Questions_Range) of Boolean;

    function Get_Question_Mask(raw : in String;
                               empty : out Boolean) return Question_Mask
    is
        cur_mask : Question_Mask := (others => False);
    begin
        empty := true;
        for C in raw'Range loop
            empty := false;
            cur_mask(Character'Pos(raw(C)) - Character'Pos('a') + 1) := true;
        end loop;

        return cur_mask;
    end Get_Question_Mask;

    function Count_Questions(mask : Question_Mask) return Natural is
        count : Natural := 0;
    begin
        for I in mask'Range loop
            if mask(I) then
                count := count + 1;
            end if;
        end loop;
        return count;
    end Count_Questions;

    cur_mask : Question_Mask := (others => False);
    next_mask : Question_Mask := (others => False);
    is_empty : Boolean;
    q_sum : Natural := 0;
    cur_count : Natural := 0;
begin

    Text_IO.Put_Line("Advent of Code: 6.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of expense values. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        next_mask := Get_Question_Mask(Text_IO.Get_Line(file), is_empty);
        if is_empty then
            cur_count := Count_Questions(cur_mask);
            Text_IO.Put_Line("Count of questions: " & Natural'Image(cur_count));
            q_sum := q_sum + Count_Questions(cur_mask);
            cur_mask := (others => False);
        else
            cur_mask := cur_mask or next_mask;
        end if;
    end loop;
    cur_count := Count_Questions(cur_mask);
    Text_IO.Put_Line("Final group Count of questions: " & Natural'Image(cur_count));
    q_sum := q_sum + Count_Questions(cur_mask);

    Text_IO.Put_Line("Total questions answered yes: " & Natural'Image(q_sum));

end Sixth;

