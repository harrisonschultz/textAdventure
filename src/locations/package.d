module locations;

public import locations.plains;
public import locations.location;
public import locations.ratsNest;

Location instantiateLocation(string className)
{
   switch (className)
   {
   case "Plains":
      return new Plains();
   case "RatsNest":
      return new RatsNest();
   default:
      return new Plains();
   }

}
