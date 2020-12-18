with Ada.Text_IO,
     Ada.Command_Line;

procedure third is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    type Map_Array is array(1..323) of String(1..31);
    map : Map_Array;
    X : Integer := 1;
    Y : Integer := 1;
    I : Integer := 1;
    tree : Integer := 0;
begin

    Text_IO.Put_Line("Advent of Code: 3.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file containing the map. Aborting.");
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

    for Y in map'Range loop
        Text_IO.Put_Line(" -> (" & Integer'Image(X) &
            ", " & Integer'Image(Y) &
            ") -> " & map(Y)(X));

        if map(Y)(X) = '#' then
            tree := tree + 1;
        end if;

        X := X + 3;
        if X > 31 then
            X := X - 31;
        end if;
    end loop;

    Text_IO.Put_Line("Trees encountered: " & Integer'Image(tree));
end third;

