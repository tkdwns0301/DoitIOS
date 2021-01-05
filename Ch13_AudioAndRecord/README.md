2021.01.05
Ch13_AudioAndRecord

1. 초기화면, stop 버튼을 눌렀을 경우
  - progress와 시간 label을 모두 초기화 시켜준다.
  <img width="587" alt="Stop" src="https://user-images.githubusercontent.com/71424672/103656579-1b8b1100-4fac-11eb-9694-94bc2262563e.png">

2. play버튼을 누를 시
  - 저장된 AudioFile을 실행해준다.
  - progress를 통해 Bar형태로 AudioFile이 어느정도 재생되었는지 확인 가능하다.
  - current Time과 endTime의 label로 재생된 시간과 남은 시간을 "00:00"의 형태로 볼 수 있다.
  - AudioFile이 모두 재생된 경우, 처음으로 다시 돌아간다.
  <img width="587" alt="Play" src="https://user-images.githubusercontent.com/71424672/103656588-1fb72e80-4fac-11eb-8d23-6b3d9e098da3.png">

3. Pause버튼을 누를 시
  - AudioFile의 실행을 정지한다.
  - current Time과 endTime은 그대로 유지한다.
  <img width="587" alt="Pause" src="https://user-images.githubusercontent.com/71424672/103656590-20e85b80-4fac-11eb-8949-fa6e166f6ad2.png">
  
4. Record switch를 "On"
  - Audio와 관련된 모든 버튼을 비활성화 시킨다.
  - record 버튼을 누를 경우 녹음이 시작되며, 녹음파일을 지정된 위치에 저장한다. 그리고 record 버튼을 stop으로 변경시켜, 녹음을 종료할 수 있도록 해준다.
  - 녹음이 끝난 경우, 위의 progress와, currentTime, EndTime을 통해 녹음된 AudioFile을 재생할 수 있다.
  <img width="587" alt="Record" src="https://user-images.githubusercontent.com/71424672/103656595-22198880-4fac-11eb-9f37-2c86215e274c.png">
  
5. Record switch를 "Off"
  - 초기실행화면으로 돌아간다.
