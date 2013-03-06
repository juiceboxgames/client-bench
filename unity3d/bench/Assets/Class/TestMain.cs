using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TestMain : MonoBehaviour, IEventListener {
	
	public GameObject testEngineClass;
	
	private bool isRunning = false;
	
	private bool hasEnded = false;
	
	private TestConfig currentTest;
	
	private ArrayList queuedTests = new ArrayList();
	
	private Dictionary<string, float> results = new Dictionary<string, float>();
	
	private int m_index = 0;
	
	private float accum   = 0; // FPS accumulated over the interval
	private int   frames  = 0; // Frames drawn over the interval
	private float timeleft; // Left time for current interval
	
	
	void Start () {
		Application.targetFrameRate = 60;
		this.guiText.text = "";
		EventManager.instance.AddListener(this as IEventListener, "BenchmarkEvent");
		
		//addTest ("Benchmark 21", 250, true, 50);
		
		addTest ("Benchmark 1", 10, false, 0);
		addTest ("Benchmark 2", 50, false, 0);
		addTest ("Benchmark 3", 250, false, 0);
		addTest ("Benchmark 4", 500, false, 0);
		
		addTest ("Benchmark 5", 10, true, 0);
		addTest ("Benchmark 6", 50, true, 0);
		addTest ("Benchmark 7", 250, true, 0);
		addTest ("Benchmark 8", 500, true, 0);
		
		addTest ("Benchmark 9", 100, true, 5);
		addTest ("Benchmark 10", 100, true, 10);
		addTest ("Benchmark 11", 100, true, 15);
		addTest ("Benchmark 12", 100, true, 20);
		addTest ("Benchmark 13", 100, true, 25);
		addTest ("Benchmark 14", 100, true, 35);
		addTest ("Benchmark 15", 100, true, 50);
	}
	
	void addTest(string name, int spriteCount, bool animate,  int workload){
		TestConfig tst = new TestConfig();
		tst.spriteCount = spriteCount;
		tst.TestName = name;
		tst.workload = workload;
		tst.animate = animate;
		this.queuedTests.Add (tst);
	}
		
	
	// Update is called once per frame
	void Update () {
		accum += Time.deltaTime;
    	frames++;
		//Debug.Log("Frames : " + frames + " Time : " + accum);
		
		if(!isRunning){
			isRunning = true;
			if(m_index >= queuedTests.Count){
				if(!hasEnded){
					hasEnded = true;
					handleEnd();
				}	
 			} else{
				TestConfig test = (TestConfig)queuedTests[m_index];
				currentTest = test;
				GameObject testEngine = (GameObject)Instantiate(testEngineClass);
				testEngine.GetComponent<TestEngine>().shouldAnimate = test.animate;
				testEngine.GetComponent<TestEngine>().numSprites = test.spriteCount;
				testEngine.GetComponent<TestEngine>().workload = test.workload;
				m_index++;
			}
			
		}
	}
	
	bool IEventListener.HandleEvent(IEvent evt)
    {
		// display two fractional digits (f2 format)
		
		float fps = frames/accum;	
		//Debug.Log(currentTest.TestName + " fps " + fps);
		accum = 0;
		results[currentTest.TestName] = fps;
		frames = 0;
		isRunning = false;
        return true;
    }
	
	void handleEnd(){
		this.guiText.text = "Results\n";
		foreach(string key in results.Keys){
			this.guiText.text += key + ":" + results[key] + "\n";
		}
	}

}
