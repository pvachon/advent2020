with Ada.Text_IO,
     Ada.Command_Line;

procedure Ninth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    --Total_Entries : constant Natural := 20;
    --Preamble_Len : constant Natural := 5;
    --Candidate : constant Long_Integer := 127;

    Total_Entries : constant Natural := 1000;
    Preamble_Len : constant Natural := 25;
    Candidate : constant Long_Integer := 776203571;


    subtype Input_Size is Natural range 1..Total_Entries;

    type Proto_Inputs is array(Natural range <>) of Long_Integer;

    subtype Inputs is Proto_Inputs(Input_Size);

    I : Natural := 1;
    raw_inputs : Inputs;

    range_min, range_max, run_sum: Long_Integer;
    run_count : Natural;
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

    for J in raw_inputs'Range loop
        range_min := Long_Integer'Last;
        range_max := 0;
        run_count := 0;
        run_sum := 0;
        -- Text_IO.Put_Line("Testing: " & Long_Integer'Image(raw_inputs(J)));
        for K in J..raw_inputs'Last loop
            if range_min > raw_inputs(K) then
                range_min := raw_inputs(K);
            end if;

            if range_max < raw_inputs(K) then
                range_max := raw_inputs(K);
            end if;

            run_sum := raw_inputs(K) + run_sum;
            run_count := run_count + 1;

            if run_sum > Candidate then
                -- Run did not sum up to the magic number
                exit;
            elsif run_sum = Candidate then
                if run_count < 2 then
                    -- Skip
                    exit;
                end if;

                Text_IO.Put_Line("Run found. Length: " & Natural'Image(run_count) &
                    " Min: " & Long_Integer'Image(range_min) &
                    " Max: " & Long_Integer'Image(range_max) &
                    " Sum: " & Long_Integer'Image(range_min + range_max));
                exit;
            end if;
        end loop;
    end loop;

end Ninth;

