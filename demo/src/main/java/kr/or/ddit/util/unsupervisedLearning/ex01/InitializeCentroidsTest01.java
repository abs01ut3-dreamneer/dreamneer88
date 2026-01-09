package kr.or.ddit.util.unsupervisedLearning.ex01;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

// 데이터 포인트 중 k개를 무작위로 선택하여 초기 중심점으로 설정
public class InitializeCentroidsTest01 {
	
	//java.util
	private static Random random = new Random();
	
	public static void main(String[] args) {
		
		List<Integer> usedIndices = new ArrayList<Integer>();
		
		// 3: 3그룹(k)
		for(int i=0; i<3; i++) {//0~2 3회 반복
			int randomIndex;
			
			do {
				// 훈련데이터의 개수: 12개
				randomIndex = random.nextInt(3);
				// Java에서 random.nextInt(12)의 범위는 0 이상 12 미만입니다.
				// 즉, 반환 가능한 값은 0부터 11까지의 정수입니다.
				System.out.println("check : randomIndex => " + randomIndex);
			}while(usedIndices.contains(randomIndex)); // usedIndices.contains(randomIndex) == true면 다시 do{}실행
			// usedIndices안에는 randomIndex와 같은 숫자가 나오지 않을때까지 do-while이 실행되어 반복되는 수가 없게 된다
			// 이 방법 기억하기
			usedIndices.add(randomIndex);
		}
		
		System.out.println("========================");
		usedIndices.forEach(System.out::println);
	}
}
