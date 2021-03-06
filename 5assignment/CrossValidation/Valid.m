clear all;
LoadData;

%% Parameters:
db = noisy_db;
clear_all = false;

if ~( exist( 'cv10_mask', 'var' ) )
    fprintf( 'loading cv10_mask.mat...\n' );
    load( 'Results/cv10_mask.mat' );
    fprintf( 'Done.\n' );
else
    fprintf( 'cv10_mask already in memory. Skipping load.\n' );
end

if ~( exist( 'DT_classifier', 'var' ) )
    fprintf( 'loading DT_classifier.mat...\n' );
    load( 'Results/DT_classifier.mat' );
    fprintf( 'Done.\n' );
else
    fprintf( 'DT_classifier already in memory. Skipping load.\n' );
end

if ~( exist( 'NN_classifier', 'var' ) )
    fprintf( 'loading NN_classifier.mat...\n' );
    load( 'Results/NN_classifier.mat' );
    fprintf( 'Done.\n' );
else
    fprintf( 'NN_classifier already in memory. Skipping load.\n' );
end

if ~( exist( 'CBR_classifier', 'var' ) )
    fprintf( 'loading DBR_classifier.mat...\n' );
    load( 'Results/CBR_classifier.mat' );
    fprintf( 'Done.\n' );
else
    fprintf( 'CBR_classifier already in memory. Skipping load.\n' );
end

[ DT_cm, DT_r, DT_p, DT_F, DT_cr ] = crossval( clean_db.x, clean_db.y, DT_classifier, @classify, cv10_mask );
[ NN_cm, NN_r, NN_p, NN_F, NN_cr ] = crossval( clean_db.x, clean_db.y, NN_classifier, @testANN, cv10_mask );
[ CBR_cm, CBR_r, CBR_p, CBR_F, CBR_cr ] = crossval( clean_db.x, clean_db.y, CBR_classifier, @basicKNNtest, cv10_mask );

for i = 1:10
    fprintf('Fold %d & ', i);
    for j = 1:length(DT_F(i, :))
        fprintf(' %3.2f ', DT_F(i, j));
    end
    fprintf(' & ');
    for j = 1:length(DT_F(i, :))
        fprintf(' %3.2f ', NN_F(i, j));
    end
    fprintf(' & ');
    for j = 1:length(DT_F(i, :))
        fprintf(' %3.2f ', CBR_F(i, j));
    end
    fprintf('\\\\ \n')
end

fprintf('***** General results ******\n');
for i = 1:length(DT_F(i, :))
fprintf('%3.2f ', mean(DT_F, 2));
fprintf('\n');
end
fprintf('\n');
for i = 1:length(DT_F(i, :))
fprintf('%3.2f ', mean(NN_F, 2));
fprintf('\n');
end
fprintf('\n');
for i = 1:length(DT_F(i, :))
fprintf(' %3.2f ', mean(CBR_F, 2));
fprintf('\n');
end
fprintf('\n');

clear db;
if clear_all
    clear all;
end
clear clear_all;