function ANNScriptLite

% not used training functions
% 'trainbfdc', 'train', 'trainb', 'trainbu', 'trainru', 'trainr', 'trainrp',
% 'trainc', 'trains', 'trainrp', 'traingd', 'traingda'
% not used transfer functions
% 'compet', 'netinv', 'tribas', 'radbas', 'radbasn', 'satlin', 'satlins', 'poslin'
% not used performance functions
% 'sse', 'rse'

perfFun = 'mse';


lr = [0.1, 0.2, 0.3];

transFun = {'tansig', 'hardlim', 'logsig','purelin', 'radbasn', 'softmax' };

trainFun = { 'trainlm', 'trainbfg', 'trainbr', 'traincgb', 'traincgf', 'traincgp', ...
    'traingdm', 'traingdx', 'trainscg'}; 

load cleandata_students;

[x2, y2] = ANNdata(x, y);

nepocs = 15;
minneurons = 3;
neurIncr = 3;
nneurons = 15;

matlabpool(2);
for tf = 1:length(transFun)
    FID_single = fopen(sprintf('results/perf_results_single_%s.txt', transFun{tf}), 'w');
    FID_multi = fopen(sprintf('results/perf_results_multi_%s.txt', transFun{tf}), 'w');
    single.transferFun = transFun{tf};
    multi.transferFun = transFun{tf};
    for tn = 1:length(trainFun)
        single.trainFun = trainFun{tn};
        multi.trainFun = trainFun{tn};
        for r = 1:length(lr)
            single.learningRate = lr(r);
            multi.learningRate = lr(r);
            sprintf('**********************************************************************')
            sprintf('prefFun=%s, lr=%d, tranFun=%s, trainFun=%s', perfFun, lr(r), transFun{tf}, trainFun{tn})
            for i=minneurons:neurIncr:nneurons
                
                single.numNeurons = i;
                net = buildNetwork(i, nepocs, [0.667, 0.33, 0], x2, y2, perfFun, lr(r), transFun{tf}, trainFun{tn});
                pred = testANN(net, x2);
                [cm, rc, pr, f, cr] = confusion(pred, y);
                fprintf(FID_single, 'for one 6-outputted NN: /n(%s, %f, %s, %s): %f', perfFun, lr(r), transFun{tf}, trainFun{tn});
                sprintf('nneurons : %d, classification rate : %f', i, cr)   
                single.confMtrx = cm;
                single.recall = rc;
                single.precision = pr;
                single.classRate = cr;

                %Build 6 networks with binary output
                l = size(y2,1);
                binaryNets = cell( l, 1 );
                for k=1:l
                    binaryNets{k} = buildNetwork( i, nepocs, [0.667, 0.33, 0], x2, y2(k,:), perfFun, lr(r), transFun{tf}, trainFun{tn} );        
                end
                pred2 = testANN(binaryNets, x2);
                [cm, rc, pr, f, cr] = confusion(pred2, y);
                fprintf(FID_multi, 'for 6 1-outputted NN: /n(%s, %f, %s, %s): %f', perfFun, lr(r), transFun{tf}, trainFun{tn});
                sprintf('nneurons : %d, classification rate : %f', i, cr)
                multi.confMtrx = cm;
                multi.recall = rc;
                multi.precision = pr;
                multi.classRate = cr;
                save(sprintf('results/perf_%s_%s_%f_%d.mat', transFun{tf}, trainFun{tn}, lr(r), i), 'single', 'multi');
            end
        end
    end
    fclose(FID_single);
    fclose(FID_multi);
end
matlabpool close;