Shader "UI/DialogBoxVertexShake"{
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }
    SubShader {
        // Need to disable batching because of the vertex animation
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
            "DisableBatching"="True"
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
        // 用于UI组件的shader都要包含一句：ZTest [unity_GUIZTestMode]，以确保UI能在前层显示
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]
        
        Pass { 
            CGPROGRAM  
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                float4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _ShakeSpeed;
            float _ShakeAmount;
            float _OffsetV;
            float _OffsetH;
            
            // 0=>-1, 1=>1
            float remap_01(float x)
            {
                return (x - 0.5) * 2;
            }

            float random()
            {
                return frac(sin(_Time.y)*100000.0);
            }

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                // 抖动幅度和方向
                float shakeMagnitude = sin(_Time.y * _ShakeSpeed) * _ShakeAmount;
                float shakeMagnitudeX = shakeMagnitude * remap_01(IN.texcoord.x);
                float shakeMagnitudeY = shakeMagnitude * remap_01(IN.texcoord.y);
                // 确定四个角的顶点偏移方向和大小
                float offsetY = remap_01(IN.texcoord.y) * remap_01(IN.texcoord.x) * _OffsetV;
                float offsetX = remap_01(IN.texcoord.x) * _OffsetH;

                OUT.vertex = UnityObjectToClipPos(IN.vertex + float4(shakeMagnitudeX + offsetX, shakeMagnitudeY + offsetY, 0, 1));
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = tex2D(_MainTex,IN.texcoord) * IN.color * _Color;
                // return color;
                // SDF抗锯齿。没看明白，效果也不明显。
                float3 c = color.rgb;
                float a = color.a;
                float smoothValue = 0;
                float delta = 6 * fwidth(IN.texcoord.x);//6*_Delta;//
                float v = IN.texcoord.x + delta;
                smoothValue = step(1.0, v) * (v -1) / delta;
                a = smoothstep(a, 0.0f, smoothValue);
                return float4(c, a);
            }
            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}
