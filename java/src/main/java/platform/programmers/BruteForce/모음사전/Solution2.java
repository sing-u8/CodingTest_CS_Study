package platform.programmers.BruteForce.모음사전;

class Solution2 {
    public int solution(String word) {
        // f[i] = 길이 i+1 이상인 접두사를 공유하는 단어 수 (자기 자신 포함)
        // f[0]=781, f[1]=156, f[2]=31, f[3]=6, f[4]=1
        int[] f = {781, 156, 31, 6, 1};
        String vowels = "AEIOU";

        int answer = 0;
        for (int i = 0; i < word.length(); i++) {
            answer += vowels.indexOf(word.charAt(i)) * f[i] + 1;
        }
        return answer;
    }
}
