import java.util.HashMap;
import java.util.HashSet;

class Solution {

	private static boolean isValidMove(int nx, int ny) {
		return -5 <= nx && nx <= 5 && -5 <= ny && ny <= 5;
	}

	private static final HashMap<Character, int[]> location = new HashMap<>();

	private static void initLocation() {
		location.put('U', new int[]{0 ,1});
		location.put('D', new int[]{0 ,-1});
		location.put('L', new int[]{-1 ,0});
		location.put('R', new int[]{1 ,0});
	}

	public int solution(String dirs) {
		initLocation();
		int x = 0, y = 0;
		HashSet<String> visited = new HashSet<>();

		for (char d : dirs.toCharArray()) {
			int[] offset = location.get(d);
			int nx = x + offset[0];
			int ny = y + offset[1];
			if (!isValidMove(nx, ny)) continue;
			visited.add(Math.min(x, nx) + " " + Math.min(y, ny) + " " + Math.max(x, nx) + " " + Math.max(y, ny));

			x = nx;
			y = ny;
		}

		return visited.size();
	}
}