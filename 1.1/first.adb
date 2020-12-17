with Ada.Text_IO,
     Ada.Command_Line;

procedure first is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    type Expense_Array is array(1..200) of Integer;
    num_array : Expense_Array;
    I : Integer := 1;
begin

    Text_IO.Put_Line("Advent of Code: 1.1");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of expense values. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        num_array(I) := Integer'Value(Text_IO.Get_Line(file));
        I := I + 1;
    end loop;

    for I in num_array'Range loop
        for J in num_array'Range loop
            if I /= J then
                for K in num_array'Range loop
                    if K /= J and K /= I then
                        if num_array(I) + num_array(J) + num_array(K) = 2020 then
                            Text_IO.Put_Line("Found: " &
                                Integer'Image(num_array(I)) &
                                " and " &
                                Integer'Image(num_array(J)) &
                                " and " &
                                Integer'Image(num_array(K)) &
                                " -> " &
                                Integer'Image(num_array(I) * num_array(J) * num_array(K)));
                        end if;
                    end if;
                end loop;
            end if;
        end loop;
    end loop;

end first;

