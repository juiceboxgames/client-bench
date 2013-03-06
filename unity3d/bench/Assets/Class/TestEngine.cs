using UnityEngine;
using System.Collections;

public class BenchmarkEvent : IEvent{
    public string Name;
	public object Data;
	
	public string GetName(){
		return "BenchmarkEvent";
	}
    public object GetData(){
		return null;
	}
	
	
}

public class TestEngine : MonoBehaviour {
	
	public GameObject tilePrefab;
	
	public int numSprites = 50;
	
	public int duration = 10;
	
	public bool shouldAnimate = true;
	
	protected ArrayList tiles = new ArrayList();
	
	protected float running = 0;
	
	private bool hasInit = false;
	
	public int workload = 0;
	
	private bool hasCleanedup = false;
	
	// Use this for initialization
	void Start () {
		
		
		
	}
	
	// Update is called once per frame
	void Update () {
		if(!hasInit){
			hasInit = true;
			doInit();
		}
		running += Time.deltaTime;
		if(running > duration){
			this.cleanup();	
		} else{
			float sum = 0;
			if(this.workload > 0){
				for(int i = 0; i < this.workload; i++){
					for(int j = 0; j < this.workload; j++){
						sum += Mathf.Sin(i) * Mathf.Cos (j);
					}
				}
			}
		}
	}
	
	void doInit(){
		for(var i = 0; i < numSprites; i++){
			GameObject tileObject = (GameObject)Instantiate(tilePrefab);
			tileObject.GetComponent<TileClass>().animate = shouldAnimate;
			tiles.Add(tileObject);
		}	
	}
	
	void cleanup(){
		if(!hasCleanedup){
			hasCleanedup = true;
			for(var i = 0; i < tiles.Count; i++){
				Destroy((GameObject)tiles[i]);	
			}

			EventManager.instance.TriggerEvent(new BenchmarkEvent());
		}
	}
}
