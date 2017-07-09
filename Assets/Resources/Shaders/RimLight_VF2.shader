//世界空间算边缘，主要在frag中实现
Shader "Custom/RimLight_VF2"
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		//_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		//_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower ("Rim Power", Range(0.5,8.0)) = 2.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0; 
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				//fixed3 color : COLOR;
				float3 normal : NORMAL;
				float3 viewDir : NORMAL2;
			};
			
			fixed4   _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4  _RimColor;
			float  _RimPower;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//世界的法线
				o.normal =  mul(v.normal, (float3x3)_World2Object); 
				//摄像机方向
				o.viewDir = _WorldSpaceCameraPos.xyz - o.vertex;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				//col *= _Color;
				half   rim = 1 - saturate(dot(i.viewDir, i.normal));
				fixed3 rimColor =  _RimColor * pow (rim, _RimPower);
				col.rgb += rimColor;
				return col;
			}
			ENDCG
		}
	}
	Fallback "VertexLit"
}
