Shader "Toy/ToyShader12"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Magnitude("Magnitude", float) = 0
        _Factora("A", float) = 0
        _Factorb("B", float) = 0
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
            float _Factora;
            float _Factorb;

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
                float2 st = IN.uv;
                fixed3 color = _Color;
                float M = _Magnitude; 
                float A = _Factora;// 多边形边数
                float B = _Factorb;

                // remap to [-1,1]
                float2 pos = (st - 0.5) * 2; 
                st = float2(atan2(pos.x, pos.y), length(pos));
                color = smoothstep(0.05, 0.051, st.y) * smoothstep(0.081, 0.08, st.y);
                float xn = (-st.x) / TWO_PI + 0.5 + _Time.y * A;
                color *= pow(frac(xn), 2) * 0.99 + 0.01;

                color = movingRing(IN.uv, 0.1, 0.05, 1.2);
                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
