with Ada.Text_IO,
     Ada.Command_Line,
     Ada.Containers.Generic_Constrained_Array_Sort;

procedure Tenth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    -- Total_Adapters : constant Natural := 11;
    --Total_Adapters : constant Natural := 31;
    Total_Adapters : constant Natural := 112;

    type Joltages is array(Natural range <>) of Natural;
    subtype Adapter_Range is Natural range 1..Total_Adapters;
    subtype Adapters is Joltages(Adapter_Range);

    all_adapters : Adapters;
    max_joltage : Natural := 1;
    I : Natural := 1;

    delta_one, delta_three : Natural := 0;

    procedure Adapter_Sort is
        new Ada.Containers.Generic_Constrained_Array_Sort(Adapter_Range, Natural, Adapters);
begin

    Text_IO.Put_Line("Advent of Code: 10.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of adapters. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        all_adapters(I) := Natural'Value(Text_IO.Get_Line(file));
        if all_adapters(I) > max_joltage then
            max_joltage := all_adapters(I);
        end if;
        I := I + 1;
    end loop;

    Text_IO.Put_Line("Device 'joltage': " & Natural'Image(max_joltage + 3));

    Adapter_Sort(all_adapters);

    if all_adapters(all_adapters'First) = 1 then
        delta_one := 1;
    elsif all_adapters(all_adapters'First) = 3 then
        delta_three := 1;
    end if;

    for J in all_adapters'First + 1..all_adapters'Last loop
        case all_adapters(J) - all_adapters(J - 1) is
            when 1 =>
                delta_one := delta_one + 1;
            when 3 =>
                delta_three := delta_three + 1;
            when others => null;
        end case;
    end loop;

    delta_three := delta_three + 1;

    Text_IO.Put_Line("Single gap: " & Natural'Image(delta_one) &
        " Three gap: " & Natural'Image(delta_three) &
        " Product: " & Natural'Image(delta_one * delta_three));

end Tenth;

