import java.util.Arrays;

public class lab6 {
    public static void main(String[] args) {
        int[] array = {0, 3, 2, 0, 5, 4, 0, 1};
        sortArray(array);
        System.out.println(Arrays.toString(array));
    }

    public static void sortArray(int[] array) {

        Integer[] sortedOdd = Arrays.stream(array)
            .filter(n -> n % 2 != 0)
            .boxed()
            .sorted((a, b) -> a - b)
            .toArray(Integer[]::new);

        Integer[] sortedEven = Arrays.stream(array)
            .filter(n -> n % 2 == 0 && n != 0)
            .boxed() 
            .sorted((a, b) -> b - a)
            .toArray(Integer[]::new);

        Integer oddIndex = 0;
        Integer evenIndex = 0;

        for (int i = 0; i < array.length; i++) {
            if (array[i] == 0) {
                continue;
            }
            if (array[i] % 2 != 0) {
                array[i] = sortedOdd[oddIndex++];
            } else {
                array[i] = sortedEven[evenIndex++];
            }
        }
    }
}
