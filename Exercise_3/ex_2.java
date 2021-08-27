import java.util.*;
import java.io.*;


public class Round {
    private ArrayList<Integer> positions;
    private int cars;
    private int cities;
    
    public Round(ArrayList<Integer> p, int car, int cit){
        positions=p;
        cars=car;
        cities=cit;
    } 
    
    
    static public ArrayList<Integer> city_moves (Round r){
        ArrayList<Integer> cm = new ArrayList<Integer>();
        int minmoves = Integer.MAX_VALUE;
        int mincity = -1;
        for (int c=0; c<r.cities; c++){
            int max =-1;
            int sum = 0;
            for (int i=0; i<r.positions.size(); i++){
                int x =  c-r.positions.get(i); 
                if (x<0) {
                    x = r.cities-r.positions.get(i)+c;
                }
                sum += x;
                if (x > max) max = x;
            }
            int sumi = sum - max;
            if (max - sumi < 2){
                if (sum < minmoves) {
                    minmoves=sum;
                    mincity=c;
                }
                else if (sum==minmoves && mincity>c){
                    mincity=c;
                }
            }
        }
        //System.out.println(minmoves);
        //System.out.println(mincity);
        cm.add(minmoves);
        cm.add(mincity);
        return cm;
    }
    
    public static void main  (String args[]) throws Exception{
        ArrayList<Integer> pos = new ArrayList<Integer>();
        File file = new File(args[0]);
        int c; 
        int car; 
        try (BufferedReader fileReader = new BufferedReader(new FileReader(args[0]))) {
        String line;
        line = fileReader.readLine();
        String[] input = line.split(" ");
        c = Integer.parseInt(input[0]);
        car = Integer.parseInt(input[1]);
        line = fileReader.readLine();
        String[] input2 = line.split(" ");
        int[] car_pos = new int[car];
        for (int i = 0; i < car; i++){
            pos.add(Integer.parseInt(input2[i]));
        }
        Round r = new Round(pos,car,c);
        ArrayList<Integer> l;
        l = city_moves(r);
        System.out.print(l.get(0));
        System.out.print(" ");
        System.out.println(l.get(1));}
        catch (Exception e){
         e.printStackTrace();
        }
        //System.out.println(l);
    }
    
}        