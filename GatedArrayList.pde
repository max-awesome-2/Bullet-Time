
import java.util.Iterator;

/**
 My own implementation of a concurrent-modification-protected array list.
 
 Problem: If you have a list of objects that you need to update, and when you update them, they
 have a chance to destroy themselves (i.e. remove themselves from the update list) that can cause
 concurrent modification exceptions.
 
 Regular solution: Keep three distinct lists - one for the objects, one for new objects to be added
 to the list, one for objects to be removed from the list. When you need to add or remove an object,
 simply add it to the add or removal list, and then loop through those lists and add / remove the
 objects OUTSIDE of the foreach loop that iterates over the main list of objects.
 
 Elegant solution (this):
 A type that builds in the 'queued' add / remove functionality, extendable to any type. Whenever
 add() or remove() is called on this bad boy, it uses internal add / removal lists to ensure that
 no concurrent modification is possible. Just make sure to call update() on this object too, each
 frame, so that it can perform the adds and removals.
 */

class GatedArrayList<T> implements Updateable, Iterable<T> {

  private ArrayList<T> mainList, addList, removalList;

  public GatedArrayList() {
    mainList = new ArrayList<T>();
    addList = new ArrayList<T>();
    removalList = new ArrayList<T>();
  }

  /**
   Adds an object to the add list.
   */
  public void add(T t) {
    addList.add(t);
  }

  /**
   Adds an object to the removal list.
   */
  public void remove(T t) {
    removalList.add(t);
  }

  /**
   Perform queued adds / removals on the main list.
   */
  @Override
    public void update() {

    // add all objects from the add list
    for (T t : addList) {
      mainList.add(t);
    }

    // clear the add list
    addList.clear();

    // remove all objects from the removal list
    for (T t : removalList) {
      mainList.remove(t);
    }

    // clear the removal list
    removalList.clear();
  }

  @Override
    public Iterator<T> iterator() {
    return mainList.iterator();
  }
}
