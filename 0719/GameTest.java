package com.ssafy.sw01.step3;

import java.util.Scanner;

public class GameTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
		int u = 0 ,c = 0;
		int N=0;
		int user,com;
		int num;
		
		System.out.println("가위바위보 게임을 시작합니다. 아래 보기중 하나를 고르시오.");
		System.out.println("1. 5판 3승");
		System.out.println("2. 3판 2승");
		System.out.println("3. 1판 1승");
		System.out.print("번호를 입력하세요 : ");
		num = sc.nextInt();
		
		switch(num) {
		case 1:
			N=3;
			break;
		case 2:
			N=2;
			break;
		case 3:
			N=1;
			break;
		}
		
		
		
		while(u<N && c<N) {
			System.out.print("가위바위보 중 하나 입력(1.가위 2.바위 3.보) : ");
			user = sc.nextInt();
			com = (int) (Math.random() * 3) +1;
			
			if((user-com)==1 || (user-com)==-2) {
				u++;
				System.out.println("이겼습니다.");
			}
			else if((user-com)==-1||(user-com)==2) {
				c++;
				System.out.println("졌습니다.");
			}
			else {
				System.out.println("비겼습니다.");
			}
		}
		
		String result;
		
		result = u > c ? " ### 유저 승리":" ### 컴퓨터 승리";
		System.out.println(u+ ":"+c+result);
		
		sc.close();

	}

}
