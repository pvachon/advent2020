with Ada.Text_IO,
     Ada.Command_Line,
     Ada.Containers.Generic_Constrained_Array_Sort;

procedure Fifth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    function Partition_Walk(loc : in String;
                            min, max : in Integer;
                            upper, lower : in Character) return Integer is
        part_min : Integer := 0;
        part_max : Integer := max;
        part_count : Integer := (max - min) + 1;
    begin
        -- Text_IO.Put_Line("  DEBUG: Spec: " & loc);
        for I in loc'Range loop
            part_count := part_count / 2;
            if loc(I) = lower then
                part_max := part_max - part_count;
            elsif loc(I) = upper then
                part_min := part_min + part_count;
            else
                Text_IO.Put_Line("Invalid direction spec: " & loc(I));
            end if;
            --Text_IO.Put_Line("  DEBUG: Count: " & Integer'Image(part_count) &
            --    " Max: " & Integer'Image(part_max) &
            --    " Min: " & Integer'Image(part_min));
        end loop;

        return part_max;

    end Partition_Walk;

    function Parse_Line(cur_loc : in String) return Integer is
        row : Integer := 0;
        col : Integer := 0;
    begin
        -- Walk the row location
        row := Partition_Walk(cur_loc(cur_loc'First..cur_loc'First + 6), 0, 127, 'B', 'F');

        -- Walk the column location
        col := Partition_Walk(cur_loc(cur_loc'First + 7..cur_loc'First + 9), 0, 7, 'R', 'L');

        -- Text_IO.Put_Line("Location (" & cur_loc & "): (" & Integer'Image(row) &
        --    "," & Integer'Image(col) &
        --    ")");

        return row * 8 + col;
    end Parse_Line;

    subtype Seat_Range is Natural range 1..960;
    type Seat_IDs is array(Seat_Range) of Integer;
    all_seat_ids : Seat_IDs;
    cur_id : Integer := 1;

    procedure Seat_ID_Sort is
        new Ada.Containers.Generic_Constrained_Array_Sort(Seat_Range, Integer, Seat_IDs);

    prev_value : Integer;
begin

    Text_IO.Put_Line("Advent of Code: 5.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of boarding passes. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        all_seat_ids(cur_id) := Parse_Line(Text_IO.Get_Line(file));
        cur_id := cur_id + 1;
    end loop;

    Seat_ID_Sort(all_seat_ids);

    prev_value := all_seat_ids(all_seat_ids'First);
    for I in all_seat_ids'First + 1 .. all_seat_ids'Last loop
        if all_seat_ids(I) /= prev_value + 1 then
            Text_IO.Put_Line("Gap: " & Integer'Image(prev_value) &
                " to " & Integer'Image(all_seat_ids(I)));
            Text_IO.Put_Line("Seat: " & Integer'Image(prev_value + 1));
        end if;
        prev_value := all_seat_ids(I);
    end loop;

end Fifth;

