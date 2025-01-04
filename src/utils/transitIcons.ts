import { 
  Plane, 
  PlaneTakeoff,
  Car, 
  Train, 
  Bus, 
  Ship, 
  Rocket, 
  Footprints,
  LucideIcon,
  MoveRight
} from 'lucide-react';

export const getTransitIcon = (transitName: string): LucideIcon => {
  const icons: Record<string, LucideIcon> = {
    private_jet: PlaneTakeoff, // Changed to PlaneTakeoff for private jets
    commercial_air: Plane,     // Regular Plane icon for commercial flights
    car: Car,
    limousine: Car,
    train: Train,
    bus: Bus,
    boat: Ship,
    space: Rocket,
    walking: Footprints
  };

  return icons[transitName] || MoveRight;
};