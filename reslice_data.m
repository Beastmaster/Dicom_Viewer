%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/9


%% Reslice Data
%
%
%
classdef reslice_data

properties
    Data  % dicom data
    m_x
    m_y
    m_z
end  %end properties


methods
    %% Constructor
    function obj = reslice_data(dd)
        obj.Data = dd;
        [obj.m_x obj.m_y obj.m_z] = size(dd) ;
    end
    
    %% Set data function
    function SetData(obj,dd)
        obj.Data = dd;
        [obj.m_x obj.m_y obj.m_z] = size(dd) ;
    end
    
    %% Reslice function
    %Direction: 'x','y','z'
    %
    function out = reslice(obj,direction,slice)
        if slice<1
            return
        end
        
        switch direction
            case 'x'
                if slice>obj.m_x
                    return
                end
                out = obj.Data(slice,:,:);
                out = permute(out,[3,2,1]);
            case 'y'
                if slice>obj.m_y
                    return
                end
                out = obj.Data(:,slice,:);
                out = permute(out,[3,1,2]);
            case 'z'
                if slice>obj.m_z
                    return
                end
                out = obj.Data(:,:,slice);
            otherwise
                disp('Error input: direction!')
                out = [];
        end 
    end
    
end %end method

end  %end class


