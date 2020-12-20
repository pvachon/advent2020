with Ada.Text_IO,
     Ada.Command_Line;

procedure Twelfth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    procedure Process_Navigation(isn : in String;
                                 ship_x, ship_y : in out Integer;
                                 waypoint_x, waypoint_y : in out Integer)
    is
        param : Integer := Integer'Value(isn(isn'First + 1..isn'Last));
        old_x : Integer := waypoint_x;
        old_y : Integer := waypoint_y;
    begin
        case isn(isn'First) is
            when 'N' => waypoint_y := waypoint_y + param;
            when 'S' => waypoint_y := waypoint_y - param;
            when 'E' => waypoint_x := waypoint_x + param;
            when 'W' => waypoint_x := waypoint_x - param;
            when 'L' =>
                while param /= 0 loop
                    waypoint_x := -waypoint_y;
                    waypoint_y := old_x;
                    old_x := waypoint_x;
                    param := param - 90;
                end loop;
            when 'R' =>
                while param /= 0 loop
                    waypoint_x := waypoint_y;
                    waypoint_y := -old_x;
                    old_x := waypoint_x;
                    param := param - 90;
                end loop;
            when 'F' =>
                ship_x := ship_x + param * waypoint_x;
                ship_y := ship_y + param * waypoint_y;
            when others =>
                Text_IO.Put_Line("Invalid instruction: " & isn(isn'First) & ", aborting.");
                return;
        end case;

        Text_IO.Put_Line("Step: " & isn & " Waypoint: (" & Integer'Image(waypoint_x) &
            ", " & Integer'Image(waypoint_y) &
            ") Ship: (" & Integer'Image(ship_x) &
            ", " & Integer'Image(ship_y) & ")");

    end Process_Navigation;

    file : Text_IO.File_Type;

    ship_x_coord, ship_y_coord : Integer := 0;

    waypoint_x_coord : Integer := 10;
    waypoint_y_coord : Integer := 1;
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
        Process_Navigation(Text_IO.Get_Line(file), ship_x_coord, ship_y_coord, waypoint_x_coord, waypoint_y_coord);
    end loop;

    Text_IO.Put_Line("Ship Coordinates: (" & Integer'Image(ship_x_coord) &
        ", " & Integer'Image(ship_y_coord) &
        ") -> " & Integer'Image(abs ship_x_coord + abs ship_y_coord));

end Twelfth;

