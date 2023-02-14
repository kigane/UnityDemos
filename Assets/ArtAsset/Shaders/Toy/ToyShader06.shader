Shader "Toy/ToyShader06"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Magnitude("Magnitude", float) = 0
    }

    SubShader
    {
        // Tags { "RenderType"="Opaque" }
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        Pass
        {
            // ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"
            #include "../Helpers.cginc"

            sampler2D _MainTex;
            fixed4 _Color;
            float _Magnitude;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            float crossS(in float2 _st, float _size){
                return  rect(_st, float2(_size,_size/16.)) +
                rect(_st, float2(_size/16.,_size));
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                // float x = IN.uv.x;
                // float y = IN.uv.y;

                // fixed3 influenced_color = fixed3(0.745,0.678,0.539);
                // fixed3 influencing_color_A = fixed3(0.653,0.918,0.985); 
                // fixed3 influencing_color_B = fixed3(0.980,0.576,0.113);
                // fixed3 color = lerp(influencing_color_A, influencing_color_B, step(0.5, x));
                // color = lerp(color, influenced_color, rect(abs((IN.uv - half2(0.5, 0))*half2(2, 1)) , fixed2(0.05, 0.125)));
                // half2 d = half2(0.25, 0.25);
                IN.uv -= 0.5;
                IN.uv = mul(rotate2d(_Time.y), IN.uv); // 顺时针转。向量逆时针旋转了，取值不会旋转，所以矩形右上角的点逆时针旋转30度后就判定为不再矩形中，因此原位置不再渲染为矩形的颜色，相当于顺时针旋转了。
                // color = lerp(color, influenced_color, 
                // smoothstep(0, 0.0002, rect(IN.uv, fixed2(0.2, 0.1)))
                // );
                IN.uv += 0.5;
                fixed3 color = crossS(IN.uv, 0.2);
                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
