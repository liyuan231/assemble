package _01;

public class Cat implements Animal,CatchMouse{
    private String name;
    private int times = 1;
    private static int instances;

    public static int getInstancesCounts() {
        return instances;
    }

    public String getName() {
        return name;
    }

    public Cat(String name, int times) {
        instances++;
        this.name = name;
        this.times = times;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Cat(String name) {
        instances++;
        this.name = name;
    }

    public int getTimes() {
        return times;
    }

    public void setTimes(int times) {
        this.times = times;
    }

    public void shout() {
        for (int i = 0; i < times; i++) {
            System.out.println("喵");
        }
    }

    @Override
    public void catchMouse() {
        System.out.println("Cat is catching mouse!");
    }
}
