module locations;

public import locations.plains;
public import locations.location;
public import locations.ratsNest;
public import locations.haydensBorough;


Location instantiateLocation(string className)
{
   switch (className)
   {
   case "Plains":
      return new Plains();
   case "RatsNest":
      return new RatsNest();
   case "HaydensBorough":
      return new HaydensBorough();
   default:
      return new Plains();
   }

}
