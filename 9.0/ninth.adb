with Ada.Text_IO,
     Ada.Command_Line;

procedure Ninth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    --Total_Entries : constant Natural := 20;
    --Preamble_Len : constant Natural := 5;
    Total_Entries : constant Natural := 1000;
    Preamble_Len : constant Natural := 25;


    subtype Input_Size is Natural range 1..Total_Entries;

    type Proto_Inputs is array(Natural range <>) of Long_Integer;

    subtype Inputs is Proto_Inputs(Input_Size);

    I : Natural := 1;
    raw_inputs : Inputs;

    function Check_Priors(priors : Proto_Inputs;
                          value : Long_Integer) return Boolean
    is

    begin
--        Text_IO.Put_Line("Value: " & Long_Integer'Image(value) &
--            " 'First: " & Natural'Image(priors'First) &
--            " 'Last:  " & Natural'Image(priors'Last) &
--            " 'Length: " & Natural'Image(priors'Length));
        for I in priors'Range loop
--            Text_IO.Put_Line("  T: " & Long_Integer'Image(priors(I)));
            for J in I..priors'Last loop
--                Text_IO.Put_Line("    + " & Long_Integer'Image(priors(J)) &
--                    " = " & Long_Integer'Image(priors(I) + priors(J)));
                if priors(I) + priors(J) = value then
                    return true;
                end if;
            end loop;
        end loop;
        return false;
    end Check_Priors;

begin

    Text_IO.Put_Line("Advent of Code: 9.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of input values. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        raw_inputs(I) := Long_Integer'Value(Text_IO.Get_Line(file));
        I := I + 1;
    end loop;

    for J in raw_inputs'First + Preamble_Len..raw_inputs'Last loop
        if not Check_Priors(raw_inputs(J - Preamble_Len .. J - 1), raw_inputs(J)) then
            Text_IO.Put_Line("Anomaly found: " & Long_Integer'Image(raw_inputs(J)));
            exit;
        end if;
    end loop;

end Ninth;

