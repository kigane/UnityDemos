using UnityEngine;

namespace Demos
{
    public class GaussianBlur : PostEffectsBase
    {
        public Shader gaussianBlurShader;
        private Material gaussianBlurMaterial = null;

        public Material material
        {
            get
            {
                gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
                return gaussianBlurMaterial;
            }
        }

        // Blur iterations - larger number means more blur.
        [Range(0, 4)]
        public int iterations = 3;
        // Blur spread for each iteration - larger value means more blur
        [Range(0.2f, 3.0f)]
        public float blurSpread = 0.6f;
        [Range(1, 8)]
        public int downSample = 2;

        /// 1st edition: just apply blur
        //	void OnRenderImage(RenderTexture src, RenderTexture dest) {
        //		if (material != null) {
        //			int rtW = src.width;
        //			int rtH = src.height;
        //			RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
        //
        //			// Render the vertical pass
        //			Graphics.Blit(src, buffer, material, 0);
        //			// Render the horizontal pass
        //			Graphics.Blit(buffer, dest, material, 1);
        //
        //			RenderTexture.ReleaseTemporary(buffer);
        //		} else {
        //			Graphics.Blit(src, dest);
        //		}
        //	} 

        /// 2nd edition: scale the render texture
        //	void OnRenderImage (RenderTexture src, RenderTexture dest) {
        //		if (material != null) {
        //			int rtW = src.width/downSample;
        //			int rtH = src.height/downSample;
        //			RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
        //			buffer.filterMode = FilterMode.Bilinear;
        //
        //			// Render the vertical pass
        //			Graphics.Blit(src, buffer, material, 0);
        //			// Render the horizontal pass
        //			Graphics.Blit(buffer, dest, material, 1);
        //
        //			RenderTexture.ReleaseTemporary(buffer);
        //		} else {
        //			Graphics.Blit(src, dest);
        //		}
        //	}

        /// 3rd edition: use iterations for larger blur
        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (material != null)
            {
                int rtW = src.width / downSample;
                int rtH = src.height / downSample;

                // 分配了一块图像缓冲区
                // 此函数针对需要快速 RenderTexture 进行一些临时计算的情况进行了优化。完成后立即使用ReleaseTemporary释放它，以便另一个调用可以在需要时开始重用它。
                // 第三个参数为深度缓冲区位数（0、16 或 24）。请注意，只有 24 位深度具有模板缓冲区
                RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
                buffer0.filterMode = FilterMode.Bilinear;

                // 屏幕图像下采样并存储在buffer0中
                Graphics.Blit(src, buffer0);

                for (int i = 0; i < iterations; i++)
                {
                    //如果您正在执行一系列后处理“blit”，最好为每个 blit 获取和释放一个临时渲染纹理，而不是预先获取一个或两个渲染纹理并重新使用它们。这对移动（基于图块的）和多 GPU 系统最有利：GetTemporary 将在内部执行DiscardContents调用，这有助于避免对先前渲染纹理内容进行代价高昂的恢复操作。
                    material.SetFloat("_BlurSize", 1.0f + i * blurSpread);

                    RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                    // Render the vertical pass
                    Graphics.Blit(buffer0, buffer1, material, 0);

                    RenderTexture.ReleaseTemporary(buffer0);
                    buffer0 = buffer1;
                    buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                    // Render the horizontal pass
                    Graphics.Blit(buffer0, buffer1, material, 1);

                    RenderTexture.ReleaseTemporary(buffer0);
                    buffer0 = buffer1;
                }

                Graphics.Blit(buffer0, dest);
                RenderTexture.ReleaseTemporary(buffer0);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
