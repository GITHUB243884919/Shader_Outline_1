using UnityEngine;
using System.Collections;

/// <summary>
/// 首先将shader制定为高光，并轮廓外发光 ："Hidden/RimLightSpecBump"
/// 当被选中时，将层设置成8，8是副摄像机定义的渲染层
/// </summary>
public class ShowSelectedBump : MonoBehaviour {

	public Shader selectedShader;
	public Color outterColor;

	
	private Color myColor ;
	private Shader myShader;
	private SkinnedMeshRenderer sRenderer;
	private bool Selected = false;

	// Use this for initialization
	void Start () 
    {
        Debug.Log(gameObject.name);
		//sRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
        sRenderer = transform.parent.parent.gameObject.GetComponentInChildren<SkinnedMeshRenderer>();
        Debug.Log(sRenderer != null);
		myColor = sRenderer.material.color;
		myShader = sRenderer.material.shader;
        string shaderName = "Hidden/RimLightSpecBump";
        //string shaderName = "Hidden/RimLightSpce";
        selectedShader = Shader.Find(shaderName);
        
		if(!selectedShader)
		{
			enabled = false;
			return;
		}
	}
	
	void SetLayerRecursively(GameObject obj,int newLayer)
	{
		obj.layer = newLayer;    
		
    	foreach (Transform child in obj.transform)
		{
			SetLayerRecursively( child.gameObject, newLayer );
   		}
	}
	
	// Update is called once per frame
	void Update () 
    {
	}
	void OnMouseEnter() {
        //renderer.material.color = Color.black;
		sRenderer.material.shader = selectedShader;
		sRenderer.material.SetColor("_RimColor",outterColor);
    }
	void OnMouseExit(){
		sRenderer.material.color = myColor;
		sRenderer.material.shader = myShader;
	}
	void OnMouseDown(){
		Selected  = !Selected;
		if(Selected)
		{
			SetLayerRecursively(gameObject,8);
			GetComponent<Animation>().Play();
		}
		else
		{
			SetLayerRecursively(gameObject,0);
			GetComponent<Animation>().Stop();
		}
			
	}
	
}
