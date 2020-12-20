with Ada.Text_IO,
     Ada.Command_Line;

procedure Twelfth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    procedure Process_Navigation(isn : in String;
                                 x, y : in out Integer;
                                 heading : in out Integer)
    is
        param : Integer := Integer'Value(isn(isn'First + 1..isn'Last));
    begin
        case isn(isn'First) is
            when 'N' => y := y + param;
            when 'S' => y := y - param;
            when 'E' => x := x + param;
            when 'W' => x := x - param;
            when 'L' => heading := (heading - param) mod 360;
            when 'R' => heading := (heading + param) mod 360;
            when 'F' =>
                case heading is
                    when 0 => -- Equivalent to heading east
                        x := x + param;
                    when 90 => -- Equivalent to heading south
                        y := y - param;
                    when 180 => -- Equivalent to heading west
                        x := x - param;
                    when 270 => -- Equivalent to heading north
                        y := y + param;
                    when others =>
                        Text_IO.Put_Line("Invalid heading: " & Integer'Image(heading));
                end case;
            when others =>
                Text_IO.Put_Line("Invalid instruction: " & isn(isn'First) & ", aborting.");
                return;
        end case;

    end Process_Navigation;

    file : Text_IO.File_Type;

    x_coord, y_coord : Integer := 0;
    heading : Integer := 0;
begin

    Text_IO.Put_Line("Advent of Code: 12.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of navigation instructions. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        Process_Navigation(Text_IO.Get_Line(file), x_coord, y_coord, heading);
    end loop;

    Text_IO.Put_Line("Coordinates: (" & Integer'Image(x_coord) &
        ", " & Integer'Image(y_coord) &
        ") -> " & Integer'Image(abs x_coord + abs y_coord));

end Twelfth;

