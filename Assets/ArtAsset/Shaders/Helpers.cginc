#ifndef MY_CG_INCLUDE
    #define MY_CG_INCLUDE

    #define PI 3.14159265359
    #define TWO_PI 6.28318530718
    
    float maxcomp(float2 vec) { return max(vec.x, vec.y); }
    float maxcomp(float3 vec) { return max(max(vec.x, vec.y), vec.z); }
    half maxcomp(half2 vec) { return max(vec.x, vec.y); }
    half maxcomp(half3 vec) { return max(max(vec.x, vec.y), vec.z); }
    // fixed maxcomp(fixed2 vec){ return max(vec.x, vec.y); }
    // fixed maxcomp(fixed3 vec){ return max(max(vec.x, vec.y), vec.z); }

    // [t1, t2] -> [s1, s2]
    half remap(half t1, half t2, half x, half s1, half s2) { return (x - t1) / (t2 - t1) * (s2 - s1) + s1; }
    half2 remap(half t1, half t2, half2 x, half s1, half s2) { return (x - t1) / (t2 - t1) * (s2 - s1) + s1; }
    
    half3 rgb2hsb(half3 c ) {
        half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        half4 p = lerp(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
        half4 q = lerp(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));
        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }

    //  Function from Iñigo Quiles
    //  https://www.shadertoy.com/view/MsS3Wc
    half3 hsb2rgb(half3 c){
        half3 rgb = clamp(abs(fmod(c.x*6.0+half3(0.0,4.0,2.0), 6.0)-3.0)-1.0, 0.0, 1.0);
        rgb = rgb*rgb*(3.0-2.0*rgb);
        return c.z * lerp(half3(1.0, 1.0, 1.0), rgb, c.y);
    }

    // YUV to RGB matrix
    // https://thebookofshaders.com/08/
    fixed3x3 yuv2rgb = fixed3x3(1.0, 0.0, 1.13983,
    1.0, -0.39465, -0.58060,
    1.0, 2.03211, 0.0);

    // RGB to YUV fixedrix
    // https://thebookofshaders.com/08/
    fixed3x3 rgb2yuv = fixed3x3(0.2126, 0.7152, 0.0722,
    -0.09991, -0.33609, 0.43600,
    0.615, -0.5586, -0.05639);

    fixed3 RGB255(float r, float g, float b)
    {
        return fixed3(r/255, g/255, b/255);
    }

    // 画水平线
    // pos 位置
    // len 粗细
    // start 左起点
    fixed3 drawHorizontalLine(fixed2 uv, float pos, float len, float start=0)
    {
        return max(1 - step(start, uv.x), step(len * 0.5, abs(uv.y - pos)));
    }
    
    // 画竖直线
    // pos 位置
    // len 粗细
    // start 下起点
    fixed3 drawVerticalLine(fixed2 uv, float pos, float len, float start=0)
    {
        return max(1 - step(start, uv.y), step(len * 0.5, abs(uv.x - pos)));
    }

    float plot(float2 uv, float pct)
    {
        return smoothstep(pct-0.02, pct, uv.y) - smoothstep(pct, pct + 0.02, uv.y);
    }
    
    // 出于性能考虑，尽可能不使用sqrt和使用sqrt的相关方法。
    float circle(in float2 _st, in float _radius){
        float2 dist = (_st - 0.5) * 2;
        _radius = pow(_radius, 2);
        return 1.-smoothstep(_radius-(_radius*0.01), _radius+(_radius*0.01), dot(dist,dist));
    }

    float rect(in float2 st, in float2 size){
        size = 0.25-size*0.25;
        float2 uv = smoothstep(size,size+size*float2(0.002, 0.002),st*(1.0-st));
        return uv.x*uv.y;
    }

    float roundedRect(float2 uv, float2 size, float lineWidth, float radius = 0.1)
    {
        uv = uv * 2 - 1;
        size -= radius;
        float d = length(max(abs(uv) - size, 0)) + min((maxcomp(abs(uv) - size)), 0);
        return smoothstep(radius, radius+lineWidth*0.5, d) * smoothstep(radius+lineWidth, radius+lineWidth*0.5, d);
    }

    float roundedRect2(float2 uv, float2 size, float lineWidth, float radius = 0.1)
    {
        uv = uv * 2 - 1;
        size -= radius;
        float d = length(max(abs(uv) - size, 0));
        return smoothstep(radius, radius + lineWidth*0.5, d) * smoothstep(radius + lineWidth, radius + lineWidth*0.5, d);
    }

    float ploygonShape(float2 uv, float sides, float radius)
    {
        uv = uv * 2 - 1;
        float angle = atan2(uv.y, uv.x);
        float slice = 2 * PI / sides;
        // -angle
        float apothem = length(uv) * cos(floor(0.5 + angle / slice) * slice - angle);
        return smoothstep(radius, radius + radius * 0.02, apothem);
    }

    // SDF
    // float rect(float2 uv, float2 size)
    // {
        //     uv = (uv - 0.5) * 2;
        //     return length(max(abs(uv)-size, 0)) + min(maxcomp(abs(uv) - size), 0);
    // }

    float2x2 rotate2d(float angle)
    {
        // 行优先存储。GLSL是列优先存储。
        return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
    }

    float movingRing(float2 uv, float radius, float width, float speed = 1)
    {
        uv = uv*2 -1;
        float2 st = float2(atan2(uv.x, uv.y), length(uv));
        // -st.x的负号改变了旋转方向。
        float theta_norm = -st.x / TWO_PI + 0.5 + _Time.y * speed;

        float pct;
        // pow(frac(theta_norm), 2)用于调变环的颜色变化过程。
        pct = pow(frac(theta_norm), 2) * 0.99 + 0.01;
        pct *= smoothstep(radius, radius + width*0.1, st.y) * smoothstep(radius + width, radius + width * 0.9, st.y);
        return pct;
    }

#endif