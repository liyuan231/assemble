package _01;

public class Dog implements Animal,CatchMouse{
    public void shout(){
        System.out.println("我的名字叫…. 汪！汪！");
    }

    @Override
    public void catchMouse() {
        System.out.println("Dog is catching mouse!");
    }
}
