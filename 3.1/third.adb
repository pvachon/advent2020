with Ada.Text_IO,
     Ada.Command_Line;

procedure third is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    type Map_Array is array(1..323) of String(1..31);
    map : Map_Array;

    function Process_Map(map : in Map_Array;
                         X_step, Y_step : in Integer) return Integer
    is
        X : Integer := 1;
        Y : Integer := map'First;
        tree : Integer := 0;
    begin

        while Y <= map'Last loop
            --Text_IO.Put_Line(" -> (" & Integer'Image(X) &
            --    ", " & Integer'Image(Y)) &
            --    ") -> " & map(Y)(X));

            if map(Y)(X) = '#' then
                tree := tree + 1;
            end if;

            X := X + X_step;
            if X > 31 then
                X := X - 31;
            end if;

            Y := Y + Y_step;
        end loop;

        Text_IO.Put_Line("Trees encountered: " & Integer'Image(tree));

        return tree;
    end Process_Map;

    file : Text_IO.File_Type;
    product : Long_Integer;

    I : Integer := 1;
begin

    Text_IO.Put_Line("Advent of Code: 3.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file containing the map, X step and Y step. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        map(I) := Text_IO.Get_Line(file);
        I := I + 1;
    end loop;

    Text_IO.Put_Line("Map has " & Integer'Image(I - 1) & " lines");

   -- Text_IO.Put_Line("(3, 1) -> " & Integer'Image(Process_Map(map, 3, 1)));
    product :=
        Long_Integer(Process_Map(map, 1, 1)) *
        Long_Integer(Process_Map(map, 3, 1)) *
        Long_Integer(Process_Map(map, 5, 1)) *
        Long_Integer(Process_Map(map, 7, 1)) *
        Long_Integer(Process_Map(map, 1, 2));

    Text_IO.Put_Line("Product: " & Long_Integer'Image(product));
end third;

