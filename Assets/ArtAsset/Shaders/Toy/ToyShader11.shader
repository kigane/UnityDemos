Shader "Toy/ToyShader11"
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
                // color = ploygonShape(st, A, M);

                // remap to [-1,1]
                float2 pos = (st - 0.5) * 2; 
                st = float2(atan2(pos.x, pos.y), length(pos));

                /**************************************
                atan2(y, x) => 正左方开始逆时针从0变化到1.
                atan2(x, y) => 正左下开始顺时针从0变化到1.
                ***************************************/
                // color = st.x / TWO_PI + 0.5;

                /***************************************
                产生锯齿形状
                ***************************************/
                // float x = IN.uv.x * A;
                // float m = min(frac(x), frac(1-x)) * 0.3;
                // color = smoothstep(m, m + 0.01, IN.uv.y);

                /****************************************
                同一角度的射线上，通过加上长度值，引入变化。
                ****************************************/
                float x = (st.x / TWO_PI + 0.5 + _Time.y * M + st.y) * A;
                float m = min(frac(x), frac(1-x)) ;
                color = 1 - smoothstep(m, m + 0.2, st.y);
                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
