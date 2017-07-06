Shader "Custom/Blur/AvergeBlur_UI"
{
	Properties
	{
		_MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
 
		_ColorMask ("Color Mask", Float) = 15
        //--------------add------------------
        _Distance ("Distance", Float) = 0.015
        //--------------add------------------
        _BlurOffsets("_BlurOffsets", Color) = (2,2,0,0)
	}
 
	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
 
		Cull Off
		Lighting Off
		ZWrite Off
		//ZTest [unity_GUIZTestMode]
		ZTest Always
        Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]
 
		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
				struct v2f {
					float4 pos : POSITION;
					half4 uv[2] : TEXCOORD0;
				};

				float4 _MainTex_TexelSize;
				float4 _BlurOffsets;

				v2f vert (appdata_img v)
				{
					v2f o;
					float offX = _MainTex_TexelSize.x * _BlurOffsets.x;
					float offY = _MainTex_TexelSize.y * _BlurOffsets.y;

					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					float2 uv = MultiplyUV (UNITY_MATRIX_TEXTURE0, v.texcoord.xy - float2(offX, offY));
				
					o.uv[0].xy = uv + float2( offX, offY);
					o.uv[0].zw = uv + float2(-offX, offY);
					o.uv[1].xy = uv + float2( offX,-offY);
					o.uv[1].zw = uv + float2(-offX,-offY);
					return o;
				}
				
				sampler2D _MainTex;
				//fixed4 _Color;

				fixed4 frag( v2f i ) : COLOR
				{
					fixed4 c;
					c  = tex2D( _MainTex, i.uv[0].xy );
					c += tex2D( _MainTex, i.uv[0].zw );
					c += tex2D( _MainTex, i.uv[1].xy );
					c += tex2D( _MainTex, i.uv[1].zw );
					return c * 0.5 ;
				}		
        ENDCG
		}
	}
    Subshader {
		Pass {
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant alpha}
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant + previous}
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant + previous}
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant + previous}		
		}

	}
}