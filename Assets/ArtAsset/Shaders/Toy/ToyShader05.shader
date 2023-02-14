Shader "Toy/ToyShader05"
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

            fixed4 frag(v2f IN) : SV_Target 
            {
                float x = IN.uv.x;
                float y = IN.uv.y;
                fixed2 toCenter = fixed2(0.5, 0.5) - IN.uv;
                float angle = atan2(toCenter.y, toCenter.x);
                float radius = length(toCenter) * 2.0;
                clip(1 - radius);

                // 光谱
                // fixed3 color = half3(x, 1, y);
                // color = hsb2rgb(color);

                // 极坐标光谱
                fixed3 color = half3((angle / TWO_PI) + 0.5, radius, 1.0);
                color = hsb2rgb(color);
                color.r = smoothstep(0, 0.2, color.r) - smoothstep(0.2, 1.0, color.r);
                color.g = smoothstep(0, 0.4, color.g) - smoothstep(0.4, 1.0, color.g);
                color.b = smoothstep(0, 0.7, color.b) - smoothstep(0.7, 1.0, color.b);
                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
