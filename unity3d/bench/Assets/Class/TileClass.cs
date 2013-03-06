using UnityEngine;
using System.Collections;
using UnityEngine;
using System.Collections;
 
class TileClass : MonoBehaviour
{
	public static int count = 0;
    public int columns = 2;
    public int rows = 2;
    public float framesPerSecond = 60f;
	public float speed = 5;
	public bool animate = true;
    //the current frame to display
    private int index = 0;
	private float i = 0;
	private float rate = 0.5f;
	private Vector3 startPos;
	private Vector3 endPos;
 
    void Start()
    {
		count++;
		this.startPos = new Vector3(-50 + (100 * Random.value), -16 + (32 * Random.value), (float)(transform.position.z + (count * .0001)));
		this.endPos = new Vector3(-50 + (100 * Random.value), -16 + (32 * Random.value), startPos.z);
		this.transform.position = startPos;
        //StartCoroutine(updateTiling());
 		index = (int)Mathf.Floor (Random.value * (rows*columns));
        //set the tile size of the texture (in UV units), based on the rows and columns
        Vector2 size = new Vector2(1f / columns, 1f / rows);
        renderer.material.SetTextureScale("_MainTex", size);
    }
 
    private void updateTiling()
    {
		
		index++;
        if (index >= rows * columns){
				index = (int)Mathf.Floor (Random.value * (rows*columns));
		}
       Vector2 offset = new Vector2((float)index / columns - (index / columns), //x index
                                          (index / columns) / (float)rows);          //y index
 
        renderer.material.SetTextureOffset("_MainTex", offset);
    }
	
	void Update () {
		updateTiling();
		if(animate){
			if(this.transform.position == this.endPos){
				this.startPos = this.endPos;
				this.endPos = new Vector3(-50 + (100 * Random.value), -16 + (32 * Random.value), transform.position.z);
				i = 0;
			}
			i += Time.deltaTime * rate;
			transform.position = Vector3.Lerp(startPos, endPos, i);
		}
	}
	
	
}
