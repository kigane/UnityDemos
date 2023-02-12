Shader "Toy/ToyShader02"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
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

            sampler2D _MainTex;
            fixed4 _Color;

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

            float lineShape(fixed2 uv)
            {
                return smoothstep(0.02, 0, abs(uv.x - uv.y));
            }

            float plot(fixed2 uv, float pct)
            {
                return smoothstep(pct-0.02, pct, uv.y) - smoothstep(pct, pct + 0.02, uv.y);
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                fixed4 fragColor;
                // 圆心移动
                float2 shifted = IN.uv - fixed2((sin(_Time.y) * 0.5 + 1)/2, (1 + cos(_Time.y) * 0.5) / 2);
                if (dot(shifted, shifted) < 0.03) // x^2+y^2 < r^2
                {
                    // Varying pixel colour
                    fixed3 col = 0.5 + 0.5*cos(_Time.y+IN.uv.xyx+half3(0,2,4));
                    fragColor = fixed4(col,1.0);
                } 
                else 
                {
                    // make everything outside the circle black
                    fragColor = _Color;
                }

                float y;
                y = pow(IN.uv.x, 5);
                return fixed4(fixed3(0, 1, 0) * plot(IN.uv, y), 1);
                // return fragColor;
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
