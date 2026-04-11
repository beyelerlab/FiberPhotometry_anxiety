function [vData,apparatusDesign_cmSP]=transformCoordinates_cmStandard2cmStandardPositive(vData,apparatusDesign_cmS)

    minX_apparatusDesign_cmS = min(apparatusDesign_cmS.x);
    minY_apparatusDesign_cmS = min(apparatusDesign_cmS.y);
    apparatusDesign_cmSP.x = apparatusDesign_cmS.x - minX_apparatusDesign_cmS;
    apparatusDesign_cmSP.y = apparatusDesign_cmS.y - minY_apparatusDesign_cmS;
    
    vData.mainX_cmSP = vData.mainX_cmS - minX_apparatusDesign_cmS;
    vData.mainY_cmSP = vData.mainY_cmS - minY_apparatusDesign_cmS;
    vData.bodyX_cmSP = vData.bodyX_cmS - minX_apparatusDesign_cmS;
    vData.bodyY_cmSP = vData.bodyY_cmS - minY_apparatusDesign_cmS;
    vData.xF_cmSP = vData.xF_cmS - minX_apparatusDesign_cmS;
    vData.yF_cmSP = vData.yF_cmS - minY_apparatusDesign_cmS;  
    
    try
    vData.landmarks_cmSP.x = vData.landmarks_cmS.x - minX_apparatusDesign_cmS;
    vData.landmarks_cmSP.y = vData.landmarks_cmS.y - minY_apparatusDesign_cmS;
    end
end